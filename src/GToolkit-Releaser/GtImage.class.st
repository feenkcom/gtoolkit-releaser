Class {
	#name : #GtImage,
	#superclass : #Object,
	#instVars : [
		'version',
		'timestamp',
		'lastOpenedVersion',
		'propertiesByKey'
	],
	#classInstVars : [
		'singleton',
		'isSyncEnabled'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #clap }
GtImage class >> commandLine [
	<commandline>

	^ (ClapCommand id: 'gtVersionInfo')
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

{ #category : #accessing }
GtImage class >> computeCurrentGToolkitVersion [
	^ IceRepository registry 
		detect: [ :anIceRepository | anIceRepository name = 'gtoolkit' ]
		ifFound: [ :gtoolkitRepository |
			| releaseTags |
			releaseTags := (gtoolkitRepository tags 
				select: #gtIsSemanticVersion
				thenCollect: [ :anIceTag | 
					anIceTag gtAsSemanticVersionNumber])
				sorted: [ :a :b | a <= b ].

			releaseTags
				ifEmpty: [ GtRlSemanticVersionNumber major: 0 minor: 0 patch: 0 ]
				ifNotEmpty: [ :theTags | theTags last ] ]
		ifNone: [ NotFound signalFor: 'gtoolkit' in: IceRepository ]
]

{ #category : #accessing }
GtImage class >> computeNextGToolkitVersion: aVersionComputation [	
	^ aVersionComputation nextSemanticVersionFrom: self computeCurrentGToolkitVersion
]

{ #category : #accessing }
GtImage class >> currentBasePharoImage [
	<gtExample>
	
	^ SystemVersion current asString
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
	<gtExample>
	singleton ifNil: [ 
	    singleton := self new.
	    singleton version: GtRlNullVersionNumber new.
	    singleton timestamp: DateAndTime now.
	].
	^ singleton
]

{ #category : #'private - instance creation' }
GtImage class >> isSyncEnabled [
	^ isSyncEnabled ifNil: [ false ]
]

{ #category : #'private - instance creation' }
GtImage class >> isSyncEnabled: aBoolean [
	isSyncEnabled := aBoolean
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

{ #category : #testing }
GtImage class >> noGtImageUpdate [
	"Answer a boolean indicating whether the image has been started with the --noGtImageUpdate option"

	^ Smalltalk commandLine argumentsInclude: '--noGtImageUpdate'
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

{ #category : #configuration }
GtImage class >> setupLepiterIntegration [
	GtPlaygroundStencil playgroundClassName: LePlayground name.
	GtInspector embeddedPlaygroundName: LeInspectorPlaygroundElement name.
]

{ #category : #'system startup' }
GtImage class >> startUp: resuming [

	(resuming not or: [ self noGtImageUpdate ])
		ifTrue: [ ^ self ].
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
GtImage class >> treemapWithAllExtensions [
	| tree |
	tree := GtNestedTreeBuilder new
			data: (Smalltalk allClassesAndTraits select: [:c | 
			{'Gt'.'Bl'.'Br'.'Le'} anySatisfy: [:p |c name beginsWith: p]]);
		groupBy: [ :aClass | aClass package ];
		groupBy: [ :aClass | aClass package classTags detect: [ :e | e hasClass: aClass ] ];
		weight: [ :aClass | aClass methods size max: 1];
		build.
	^ GtNestedRectangleTreeMap new
		roots: { tree };
		leaves: [ :aNode | aNode leaves ];
		deep: [ :aNode | aNode nodes ];
		leavesSize: [ :aNode | aNode weight ];
		containerElement: [ :anElement :aNodeContext | 
			aNodeContext level = 2 ifTrue: [ 
				anElement addChild: (BrLabel new 
					text: (aNodeContext  model name name withoutPrefix: 'GToolkit-'); 
					aptitude: (BrGlamorousLabelAptitude new fontSize: 8; foreground: Color gray); 
					constraintsDo: [ :c | c ignoreByLayout. ])].
			anElement border: (BlBorder 
				paint: (Color gray alpha: 0.7 / aNodeContext level) 
				width: 1).
			anElement padding: (BlInsets all: 1) ];
		leafElement: [ :anElement :aLeafContext | 
			| isGtView isGtExample |
			isGtView := aLeafContext model item itOrItsSuperclassesDefineGTViews.
			isGtExample := aLeafContext model item methods anySatisfy: [ :aMethod | 
				aMethod isGTExampleMethod ].
			anElement border: (BlBorder 
				paint: (Color gray alpha: 0.5 / aLeafContext level) 
				width: 1).
			anElement background: (isGtView 
				ifTrue: [(Color blue alpha: 0.6)] 
				ifFalse: [ 
					isGtExample 
						ifTrue: [ Color green muchDarker alpha: 0.6] 
						ifFalse: [ Color transparent ]]) ].
]

{ #category : #accessing }
GtImage class >> version [
	^ self instance version
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
		title: 'Commit info' translated;
		priority: 11;
		items: [ self commitInfo ];
		column: 'Repository' translated text: [ :each | each key asString ];
		column: 'Commit' translated text: [ :each | each value asString ].
]

{ #category : #accessing }
GtImage >> gtExtensionPragmas: aView [
	<gtView>
	^ aView columnedList
		title: 'Extension pragmas';
		priority: 30;
		items: [ (GtPragmaType all select: [ :each | each keyword beginsWith: 'gt' ])
				sorted: [ :a :b | a keyword < b keyword ] ];
		column: 'Pragma' text: [ :each | each ];
		column: 'Usages' text: [ :each | each pragmas size ]
]

{ #category : #accessing }
GtImage >> gtExtensionsFor: aView [
	<gtView>
	| inspectorPragmas spotterPragmas coderAddOnsPragmas coderContextMenuPragmas advicePragmas actionPragmas lepiterSnippets exceptionPragmas contextPragmas classPragmas classActionPragmas |
	^ aView columnedList
		title: 'Main extensions';
		priority: 20;
		items: [ 
			inspectorPragmas := GtInspector extensionsPragma gtPragmas.
			exceptionPragmas := #gtExceptionView gtPragmas.
			contextPragmas := #gtContextView gtPragmas.
			classPragmas := #gtClassView gtPragmas.
			spotterPragmas := GtSpotter extensionsPragma gtPragmas.
			coderAddOnsPragmas := GtCoderModel astExtensionsPragma gtPragmas.
			coderContextMenuPragmas := GtCoderModel contextMenuAddOnsPragma gtPragmas.
			actionPragmas := #gtAction gtPragmas.
			classActionPragmas := #gtClassAction gtPragmas.
			advicePragmas := #gtAdvice gtPragmas.
			lepiterSnippets := LeSnippet allSubclasses select: [:each | each class includesSelector: #leJsonV4Name ].
			{
				{'Inspector views' . inspectorPragmas . inspectorPragmas size}.
				{'Debugger exception views' . exceptionPragmas . exceptionPragmas size}.
				{'Debugger context views' . contextPragmas . contextPragmas size}.
				{'Coder class views' . classPragmas . classPragmas size}.
				{'Object actions' . actionPragmas . actionPragmas size}.
				{'Coder class actions' . classActionPragmas . classActionPragmas size}.
				{'Search extensions' . spotterPragmas . spotterPragmas size}.
				{'Coder AST add ons' . coderAddOnsPragmas . coderAddOnsPragmas size}.
				{'Coder menu add ons' . coderContextMenuPragmas . coderContextMenuPragmas size}.
				{'Advices' . advicePragmas . advicePragmas size}.
				{'Lepiter snippets' . lepiterSnippets . lepiterSnippets size}.
			} ];
		column: 'Property' text: [ :each | each first ];
		column: 'Value' text: [ :each | each last ];
		send: #second
]

{ #category : #ui }
GtImage >> gtImageInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Image info' translated;
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
		title: 'OS info' translated;
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
		items: [ 
			{
				('GT version' -> self version versionString).
				('GT release timestamp' -> self timestamp).
				('Image directory' -> Smalltalk image imageDirectory).
				('Image file' -> Smalltalk image imageFile resolve basename).
				('Base image info' -> (String streamContents: [ :s | self imageInfoOn: s])).
				"'License' -> self licenseString."
				('Virtual Machine' -> Smalltalk vm).
				('Last opened version' -> (self lastOpenedVersion ifNil: ['?'] ifNotNil: [:v | v versionString ])).
				('Preferences directory') -> self class defaultPreferencesFolder
			}, (self properties collect: [ :aProperty | 
				aProperty name -> aProperty description ]) ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ] weight: 2;
		send: #value
]

{ #category : #accessing }
GtImage >> gtTreemapWithAllExtensionsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Extensions treemap';
		stencil: [ self class treemapWithAllExtensions ]
]

{ #category : #ui }
GtImage >> gtVmInfoFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'VM info' translated;
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

{ #category : #initialization }
GtImage >> initialize [
	super initialize.
	propertiesByKey := OrderedDictionary new.
]

{ #category : #testing }
GtImage >> isDevVersion [
	^ self version isDevVersion
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

{ #category : #'accessing - properties' }
GtImage >> properties [
	^ propertiesByKey values
]

{ #category : #'accessing - properties' }
GtImage >> propertyAt: aPropertyKey [
	"Answer the property value associated with aKey."
	
	^ self 
		propertyAt: aPropertyKey 
		ifAbsent: [ self error: 'Property not found' ].
]

{ #category : #'accessing - properties' }
GtImage >> propertyAt: aPropertyKey ifAbsent: aBlock [
	^ propertiesByKey
		at: aPropertyKey
		ifAbsent: aBlock
]

{ #category : #'accessing - properties' }
GtImage >> propertyAt: aPropertyKey ifAbsentPut: aBlock [
	^ propertiesByKey
		at: aPropertyKey
		ifAbsentPut: aBlock
]

{ #category : #'accessing - properties' }
GtImage >> propertyAt: aPropertyKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock [

	^ propertiesByKey
		  at: aPropertyKey
		  ifPresent: aPresentBlock
		  ifAbsent: anAbsentBlock
]

{ #category : #'accessing - properties' }
GtImage >> propertyAt: aPropertyKey put: anImageProperty [
	^ propertiesByKey
		at: aPropertyKey
		put: anImageProperty
]

{ #category : #'accessing - properties' }
GtImage >> setProperty: anImageProperty [
	self
		propertyAt: anImageProperty key 
		put: anImageProperty
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
