Class {
	#name : #GtRlProjectsCloner,
	#superclass : #Object,
	#instVars : [
		'loadedProjectsByName',
		'loadedRepositoriesById'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #'private - building' }
GtRlProjectsCloner >> createBaselineProjectForPackage: baselinePackage fromRepository: aRepositoryLocationString [
	| baselineClassName baselineClass |
	baselineClassName := baselinePackage name.
	baselineClass := baselinePackage classes
		detect: [ :each | each name = baselineClassName ].
	
	^ GtRlLocalDependenciesModelBuilder new
		buildProjectFromBaselineClass: baselineClass
		withRepositoryDescription: aRepositoryLocationString.
	
]

{ #category : #logging }
GtRlProjectsCloner >> emitBaselineAlreadyLoadedFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineAlreadyLoadedEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloner >> emitLoadCompletedEventFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineLoadCompletedEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloner >> emitLoadStartEventFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineLoadStartedEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloner >> emitPackageLoadFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselinePackageLoadEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #'private - building' }
GtRlProjectsCloner >> ensureRepositoryCloneFor: aRepositoryLocationString [
	| mcRepositorySpec mcRepository |
	mcRepositorySpec := MetacelloRepositorySpec new 
		description: aRepositoryLocationString.
	
	(MetacelloPlatform current canHandleType: mcRepositorySpec type)
		ifFalse: [ ^ Error signal: 'Cannot load' ].
	
	mcRepository := Iceberg mcRepositoryFor: mcRepositorySpec description.
	self ensureRepositoryRegisteredFor: aRepositoryLocationString.
	
	^ mcRepository repository
]

{ #category : #'private - building' }
GtRlProjectsCloner >> ensureRepositoryRegisteredFor: aRepositoryLocationString [
	| repository |
	"This is a hack as we are missing a url model. So we create
	and use a temporary repository to work with urls."
	repository := GtRlRepository 
		fromUrlString: aRepositoryLocationString.
	
	(loadedRepositoriesById includesKey: repository id asLowercase) 
		ifFalse: [ 
			loadedRepositoriesById at: repository id asLowercase put: repository ].
]

{ #category : #testing }
GtRlProjectsCloner >> ensureSameRepositoryForBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| loadedProject |
	(loadedProjectsByName includesKey: aBaselineName) ifFalse: [ ^ self ].
	
	loadedProject := loadedProjectsByName at: aBaselineName.
	(loadedProject repository urlString = aRepositoryLocationString) ifFalse: [ 
		GtRlClonerDifferentBaselineRepositoryError new
			baselineName: aBaselineName;
			repositoryUrlString: aRepositoryLocationString;
			signal ]
]

{ #category : #testing }
GtRlProjectsCloner >> ensureSingleRepositoryVersionFor: aRepositoryLocationString forBaseline: aBaselineName [
	| toLoadRepository loadedRepository  |
	
	"This is a hack as we are missing a url model. So we create
	and use a temporary repository to work with urls."
	toLoadRepository := GtRlRepository 
		fromUrlString: aRepositoryLocationString.
		
	(loadedRepositoriesById includesKey: toLoadRepository id asLowercase) 
		ifFalse: [ ^ self ].

	loadedRepository := loadedRepositoriesById at: toLoadRepository id asLowercase.
	"In case we try to load two different versions for the same repository
	we raise an error."
	(loadedRepository versionOrNil = toLoadRepository versionOrNil) ifFalse: [ 
		GtRlClonerDifferentRepositoryVersionError new
			baselineName: aBaselineName;
			repositoryUrlString: aRepositoryLocationString;
			signal ] 
]

{ #category : #initialization }
GtRlProjectsCloner >> initialize [
	super initialize.
	loadedProjectsByName := OrderedDictionary new.
	loadedRepositoriesById := OrderedDictionary new.
]

{ #category : #testing }
GtRlProjectsCloner >> isBaselineNamedAlreadyLoadedFor: aBaselineName [
	^ loadedProjectsByName includesKey: aBaselineName
]

{ #category : #loading }
GtRlProjectsCloner >> loadBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| baselinePackage project |
	
	self 
		emitLoadStartEventFor: aBaselineName fromRepository: aRepositoryLocationString.
	(self 
		shouldLoadBaselineNamed: aBaselineName 
		fromRepository: aRepositoryLocationString) ifFalse: [ ^ self ].
	
	baselinePackage := self 
		loadBaselinePackageFor: aBaselineName 
		fromRepository: aRepositoryLocationString.
	
	project := self 
		createBaselineProjectForPackage: baselinePackage
		fromRepository: aRepositoryLocationString.
	loadedProjectsByName 
		at: project
		put: aBaselineName.
	
	self loadProjectDependenciesFor: project.
	self 
		emitLoadCompletedEventFor: aBaselineName fromRepository: aRepositoryLocationString.
	
	^ project
]

{ #category : #loading }
GtRlProjectsCloner >> loadBaselinePackageFor: aBaselineName fromRepository: aRepositoryLocationString [
	| icebergRepository icebergPackage baselineClassName |
	baselineClassName := MetacelloScriptEngine baselineNameFrom: aBaselineName.
	
	icebergRepository := self ensureRepositoryCloneFor: aRepositoryLocationString.
	(icebergRepository workingCopy packageNames 
		includes: baselineClassName)
			ifFalse: [ Error signal: 'Cannot find baseline package' ].
	
	self 
		emitPackageLoadFor: aBaselineName
		fromRepository: aRepositoryLocationString.
	icebergPackage := icebergRepository workingCopy packageNamed: baselineClassName.
	icebergPackage load.
	
	^ RPackage organizer 
		packageNamed: icebergPackage name
]

{ #category : #loading }
GtRlProjectsCloner >> loadProjectDependenciesFor: aBaselineProject [
	aBaselineProject childProjects do: [ :aProject |
		self 
			loadBaseline: aProject name 
			fromRepository: aProject repository urlString ].
]

{ #category : #testing }
GtRlProjectsCloner >> shouldLoadBaselineNamed: aBaselineName fromRepository: aRepositoryLocationString [
	"Ensure that we can load the baseline without having conflictual repositories 
	or baselines loaded. Throw an error if there is a conflict from which we 
	cannot recover."
	
	self 
		ensureSingleRepositoryVersionFor: aRepositoryLocationString
		forBaseline: aBaselineName.
	self 
		ensureSameRepositoryForBaseline: aBaselineName 
		fromRepository: aRepositoryLocationString.
		
	(self isBaselineNamedAlreadyLoadedFor: aBaselineName) ifTrue: [
		self 
			emitBaselineAlreadyLoadedFor: aBaselineName
			fromRepository: aRepositoryLocationString.
		^ false].
		

	^ true
]
