Class {
	#name : #GtImage,
	#superclass : #Object,
	#instVars : [
		'version',
		'timestamp',
		'lastOpenedVersion'
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
GtImage class >> defaultPreferences [
	^ FileLocator preferences / 'pharo' / 'org.glamoroustoolkit.last-opened-version.ston'
]

{ #category : #'class initialization' }
GtImage class >> initialize [
	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory  
		atPriority: SessionManager default defaultPriority.
	
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

{ #category : #loading }
GtImage class >> loadLastOpenedVersion [
	| versionString |
	versionString := self defaultPreferences readStreamDo: [ :aReadStream | STON fromStream: aReadStream].
	^ GtRlSemanticVersionNumber createFromString: versionString.
]

{ #category : #accessing }
GtImage class >> reset [
	singleton := nil
]

{ #category : #'load and saving' }
GtImage class >> save: aValue into: aWriteStream [
	STON put: aValue onStreamPretty: (ZnCharacterWriteStream on: aWriteStream encoding: 'utf8')
]

{ #category : #'system startup' }
GtImage class >> startUp: resuming [
	| lastOpenedVersion |
	resuming
		ifFalse: [ ^ self ].
	self defaultPreferences exists
		ifFalse: [ self updateLastOpenedVersion.
			NonInteractiveTranscript stdout
				show: 'Preference file does not exist. Creating...' ].
	lastOpenedVersion := self loadLastOpenedVersion.
	NonInteractiveTranscript stdout
		show: 'Last opened version ';
		show: lastOpenedVersion printString.
	self instance lastOpenedVersion: lastOpenedVersion.
	self instance version isSemanticVersion ifFalse:
		[ self error: 'Image setup is not complete, see GtImageSetup>>performLocalSetup' ].
	(lastOpenedVersion isSemanticVersion not or: [ self instance version > lastOpenedVersion ])
		ifTrue: [ self updateLastOpenedVersion ].
]

{ #category : #accessing }
GtImage class >> timestamp: aTimestamp [
	self instance timestamp: aTimestamp
]

{ #category : #'load and saving' }
GtImage class >> updateLastOpenedVersion [
	self defaultPreferences
		writeStreamDo:
			[ :aPreferenceStream | self save: self instance version versionString into: aPreferenceStream ].
	
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

{ #category : #ui }
GtImage >> gtCommitInfoFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Commit Info' translated;
		priority: 11;
		items: [ self commitInfo ];
		column: 'Repository' translated 
			do: [ :column | column item: [ :each | each key asString ] ];
		column: 'Commit' translated 
			do: [ :column | column item: [ :each | each value asString ] ].
]

{ #category : #ui }
GtImage >> gtImageInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Image Info' translated;
		priority: 12;
		look: BrGlamorousCodeEditorLook new;
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
		look: BrGlamorousCodeEditorLook new;
		text: [ info asRopedText ]
]

{ #category : #ui }
GtImage >> gtPreviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ 
			{'GT version' -> self version versionString. 
			'GT release timestamp' -> self timestamp.
			'Image directory' -> Smalltalk image imageDirectory asFileReference.
			'Image format version' -> Smalltalk image imageFormatVersion.
			"'License' -> self licenseString."
			'VM' -> Smalltalk vm } ];
		column: 'Property' format: [:each | each key];
		column: 'Value' format: [:each | each value ];
		send: #value
]

{ #category : #ui }
GtImage >> gtVmInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'VM Info' translated;
		priority: 13;
		look: BrGlamorousCodeEditorLook new;
		text: [ (String streamContents: [ :s | self vmInfoOn: s]) asRopedText ]
]

{ #category : #private }
GtImage >> imageInfoOn: aStream [

	aStream 
		<< SystemVersion current asString;
		cr.
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
