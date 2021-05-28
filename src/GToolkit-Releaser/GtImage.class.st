Class {
	#name : #GtImage,
	#superclass : #Object,
	#instVars : [
		'version',
		'timestamp',
		'lastOpenedVersion',
		'isLepiterEnabled'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #clap }
GtImage class >> commandLine [
	<commandline>

	^ (ClapCommand withName: 'gtVersionInfo')
		description: 'Gtoolkit version information';
		add: ClapFlag forHelp;
		meaning: [ :args | | stdout |
			stdout := ZnNewLineWriterStream on: Stdio stdout.
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			self instance summaryOn: stdout ]
]

{ #category : #configuration }
GtImage class >> defaultPreferencesFolder [
	^ FileLocator preferences / 'pharo'
]

{ #category : #'load and saving' }
GtImage class >> ensureLastOpenVersionPreferences [
	"In case there is no data for the last opened version we store the current version."
	self lastOpenVersionPreferences exists ifFalse: [ 
		self storeLastOpenedVersion ]
]

{ #category : #'class initialization' }
GtImage class >> initialize [
	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory  
		atPriority: SessionManager default defaultPriority.
	
]

{ #category : #'system startup' }
GtImage class >> initializeLastOpenedVersion [
	| lastOpenedVersion |
	
	self ensureLastOpenVersionPreferences.
	
	lastOpenedVersion := self loadLastOpenedVersion.
	self instance lastOpenedVersion: lastOpenedVersion.
	self instance version isSemanticVersion ifFalse: [ 
		"In case the image version is not set do not attemot to update 
		the last opened version preference on disk."
		'Image setup is not complete: missing local version (see GtImageSetup>>performLocalSetup)' traceCr.
		^ self ].
	
	(lastOpenedVersion isSemanticVersion not or: [ self instance version > lastOpenedVersion ])
		ifTrue: [ self storeLastOpenedVersion ].
]

{ #category : #accessing }
GtImage class >> instance [ 
	singleton ifNil: [ 
	    singleton := self new.
	    singleton version: GtRlNullVersionNumber new.
	    singleton timestamp: DateAndTime now.
	].
	^ singleton
]

{ #category : #accessing }
GtImage class >> isLepiterEnabled [ 
	^ self instance isLepiterEnabled 
]

{ #category : #configuration }
GtImage class >> lastOpenVersionPreferences [
	^ self defaultPreferencesFolder / 'com.glamoroustoolkit.last-opened-version.v1.ston'
]

{ #category : #'load and saving' }
GtImage class >> loadLastOpenedVersion [
	| rawData versionString |
	rawData := self lastOpenVersionPreferences readStreamDo: [ :aReadStream | 
		STONJSON fromStream: aReadStream].
	
	(rawData isDictionary and: [ rawData includesKey: 'data' ]) ifFalse: [  
		"Validate "
		^ GtRlNullVersionNumber new ].
	
	versionString := rawData at: 'data'.
	versionString = GtRlNullVersionNumber versionString ifTrue: [ 
		^ GtRlNullVersionNumber new ].
	^ (GtRlSemanticVersionNumber canCreateFromString: versionString)
		ifTrue: [ GtRlSemanticVersionNumber createFromString: versionString ]
		ifFalse: [ GtRlNullVersionNumber new ]
]

{ #category : #accessing }
GtImage class >> reset [
	singleton := nil
]

{ #category : #'load and saving' }
GtImage class >> saveJsonFor: aValue into: aWriteStream [
	STONJSON 
		put: aValue 
		onStreamPretty: (ZnCharacterWriteStream on: aWriteStream encoding: 'utf8')
]

{ #category : #'system startup' }
GtImage class >> startUp: resuming [
	resuming
		ifFalse: [ ^ self ].
	self initializeLastOpenedVersion.
]

{ #category : #'load and saving' }
GtImage class >> storeLastOpenedVersion [
	self defaultPreferencesFolder ensureCreateDirectory.
	self lastOpenVersionPreferences
		writeStreamDo: [ :aPreferenceStream | 
			self 
				saveJsonFor: {
					'schema' -> 'v1'.
					'data' -> self instance version versionString } asDictionary 
				into: aPreferenceStream ]
	
]

{ #category : #accessing }
GtImage class >> timestamp: aTimestamp [
	self instance timestamp: aTimestamp
]

{ #category : #accessing }
GtImage class >> version [
	^ self instance
]

{ #category : #accessing }
GtImage class >> version: aVersion [
	self instance version: aVersion
]

{ #category : #private }
GtImage >> commitInfo [
	"Answer information about the current commitish for each repository"

	^ Array streamContents: [ :stream |
		(IceRepository registry
			sorted: [ :a :b | a name < b name ])
				select: [ :each | self shouldReportRepository: each ]
				thenDo: [ :repository |
					stream nextPut: repository name -> repository headCommit id ] ]
]

{ #category : #private }
GtImage >> commitInfoOn: aStream [
	"Write the repository commit numbers on a stream"

	self commitInfo do: [ :each |
		aStream
			<< each key;
			<< ': ';
			<< each value;
			cr ].
]

{ #category : #accessing }
GtImage >> enableLepiter [
	isLepiterEnabled := true.
]

{ #category : #ui }
GtImage >> gtCommitInfoFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Commit Info' translated;
		priority: 11;
		items: [ self commitInfo ];
		column: 'Repository' translated item: [ :each | each key asString ];
		column: 'Commit' translated item: [ :each | each value asString ].
]

{ #category : #ui }
GtImage >> gtImageInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Image Info' translated;
		priority: 12;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ (String streamContents: [ :s | self imageInfoOn: s]) asRopedText ]
]

{ #category : #ui }
GtImage >> gtOSInfoFor: aView [
	<gtView>

	| info |
	info := String streamContents: [ :s | self osInfoOn: s ].
	info ifEmpty: [ ^ aView empty ].
	^ aView textEditor 
		title: 'OS Info' translated;
		priority: 14;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ info asRopedText ]
]

{ #category : #ui }
GtImage >> gtPreferencesFilesFor: aView [
	<gtView >
	^ self class defaultPreferencesFolder exists 
		ifTrue: [ (self class defaultPreferencesFolder gtItemsFor: aView)
			title: 'Preferences directory';
			priority: 50 ]
		ifFalse: [ aView empty ]
]

{ #category : #ui }
GtImage >> gtPreviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {('GT version' -> self version versionString).
			('GT release timestamp' -> self timestamp).
			('Image directory'
				-> Smalltalk image imageDirectory asFileReference).
			('Image format version' -> Smalltalk image imageFormatVersion).
			"'License' -> self licenseString."
			('VM' -> Smalltalk vm).
			('Last opened version' -> self lastOpenedVersion versionString)} ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: #value
]

{ #category : #ui }
GtImage >> gtVmInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'VM Info' translated;
		priority: 13;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ (String streamContents: [ :s | self vmInfoOn: s]) asRopedText ]
]

{ #category : #private }
GtImage >> imageInfoOn: aStream [

	aStream 
		<< SystemVersion current asString;
		cr.
]

{ #category : #accessing }
GtImage >> isLepiterEnabled [
	^ isLepiterEnabled ifNil: [ false ]
]

{ #category : #accessing }
GtImage >> lastOpenedVersion [
	^ lastOpenedVersion. 
]

{ #category : #accessing }
GtImage >> lastOpenedVersion: anObject [
	lastOpenedVersion := anObject
]

{ #category : #private }
GtImage >> osInfoOn: aStream [
	"Write information about the host operating system, if available"
	| osInfoFile |

	osInfoFile := '/etc/os-release' asFileReference.
	osInfoFile isReadable ifTrue: 
		[ aStream 
			nextPutAll: osInfoFile contents;
			cr ].
]

{ #category : #private }
GtImage >> shouldReportRepository: aRepository [

	^ aRepository remotes
		detect: [ :each | | info owner |
			info := each detailedInfo asDictionary.
			owner := info at: 'Repo Owner' ifAbsent: [ nil ].
			owner = 'feenkcom' ]
		ifFound: [ true ] 
		ifNone: [ false ].
]

{ #category : #accessing }
GtImage >> summary [ 
	"Answer a string with all image information"

	^ String streamContents: [ :stream |
		self summaryOn: stream ]
]

{ #category : #private }
GtImage >> summaryOn: stream [
	"Answer a string with all image information"

	stream 
		<< 'GT version: ';
		<< self version versionString; cr;
		<< 'GT release timestamp: ';
		print: self timestamp; cr;
		<< 'Pharo Image: '.
	self imageInfoOn: stream.
	stream
		cr;
		<< 'VM:'; cr.
	self vmInfoOn: stream.
	stream 
		cr;
		<< 'Commit Info:'; cr.
	self commitInfoOn: stream.
	stream 
		cr;
		<< 'OS Info:'; cr.
	self osInfoOn: stream.
	stream cr.
]

{ #category : #private }
GtImage >> systemInfoOn: aStream [

	self commitInfoOn: aStream.
	aStream cr; cr.
	self imageInfoOn: aStream.
	aStream cr; cr.
	self vmInfoOn: aStream.

]

{ #category : #accessing }
GtImage >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GtImage >> timestamp: anObject [
	timestamp := anObject
]

{ #category : #accessing }
GtImage >> version [
	^ version
]

{ #category : #accessing }
GtImage >> version: anObject [
	version := anObject
]

{ #category : #private }
GtImage >> vmInfoOn: aStream [

	aStream
		<< Smalltalk vm version;
		cr.

]
