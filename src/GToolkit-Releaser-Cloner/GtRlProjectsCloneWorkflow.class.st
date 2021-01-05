Class {
	#name : #GtRlProjectsCloneWorkflow,
	#superclass : #Object,
	#instVars : [
		'loadedProjectsByName',
		'repositoriesCacheById',
		'initialIcebergRepos'
	],
	#category : #'GToolkit-Releaser-Cloner-Core'
}

{ #category : #'private - building' }
GtRlProjectsCloneWorkflow >> createBaselineProjectForPackage: baselinePackage fromRepository: aRepositoryLocationString [
	| baselineClassName baselineClass |
	baselineClassName := baselinePackage name.
	baselineClass := baselinePackage classes
		detect: [ :each | each name = baselineClassName ].
	
	^ GtRlLocalDependenciesModelBuilder new
		buildProjectFromBaselineClass: baselineClass
		withRepositoryDescription: aRepositoryLocationString.
	
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitBaselineAlreadyLoadedFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineSkipLoadEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitLoadCompletedEventFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineLoadCompletedEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitLoadStartEventFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselineLoadStartedEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitPackageLoadFor: aBaselineName fromRepository: aRepositoryLocationString [
	GtRlClonerBaselinePackageLoadEvent new
		baselineName: aBaselineName;
		repositoryUrlString: aRepositoryLocationString;
		emit
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> ensureNoConflictWithIcebergRepoFor: aRepositoryLocationString forBaseline: aBaselineName [
	| toLoadRepository icebergRepo repoVersion |
	toLoadRepository := GtRlRepository 
		fromUrlString: aRepositoryLocationString.
	
	icebergRepo := initialIcebergRepos  
		detect: [ :anIcebergRepo | 
			anIcebergRepo name asLowercase = toLoadRepository repositoryName asLowercase ]
		ifNone: [ ^ self ].
		
	((icebergRepo isMissing) or: [ 
		(icebergRepo hasRemoteNamed: 'origin') not ]) ifTrue: [ 
			Error signal: 'Iceberg repo is missing origin. Not supported currently!' ].
	
	repoVersion := toLoadRepository versionStringOrNil ifNil: [ 'master' ].
	((toLoadRepository projectPath = icebergRepo origin projectPath) and: [ 
		toLoadRepository repoPath = icebergRepo subdirectory and: [
			repoVersion = icebergRepo head description ] ]) ifFalse: [ 
				Error signal: 'Confict with local iceberg repo' ]
]

{ #category : #'private - building' }
GtRlProjectsCloneWorkflow >> ensureRepositoryCloneFor: aRepositoryLocationString [
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
GtRlProjectsCloneWorkflow >> ensureRepositoryRegisteredFor: aRepositoryLocationString [
	| repository |
	"This is a hack as we are missing a url model. So we create
	and use a temporary repository to work with urls."
	repository := GtRlRepository 
		fromUrlString: aRepositoryLocationString.
	
	(repositoriesCacheById includesKey: repository id asLowercase) 
		ifFalse: [ 
			repositoriesCacheById at: repository id asLowercase put: repository ].
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> ensureSameRepositoryForBaseline: aBaselineName fromRepository: aRepositoryLocationString [
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
GtRlProjectsCloneWorkflow >> ensureSingleRepositoryVersionFor: aRepositoryLocationString forBaseline: aBaselineName [
	| toLoadRepository loadedRepository  |
	
	"This is a hack as we are missing a url model. So we create
	and use a temporary repository to work with urls."
	toLoadRepository := GtRlRepository 
		fromUrlString: aRepositoryLocationString.
		
	(repositoriesCacheById includesKey: toLoadRepository id asLowercase) 
		ifFalse: [ ^ self ].

	loadedRepository := repositoriesCacheById at: toLoadRepository id asLowercase.
	"In case we try to load two different versions for the same repository
	we raise an error."
	(loadedRepository versionStringOrNil = toLoadRepository versionStringOrNil) ifFalse: [ 
		GtRlClonerDifferentRepositoryVersionError new
			baselineName: aBaselineName;
			repositoryUrlString: aRepositoryLocationString;
			signal ] 
]

{ #category : #'gt extensions' }
GtRlProjectsCloneWorkflow >> gtViewLoadedProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Loaded Projects';
		priority: 15;
		items: [ loadedProjectsByName values ]
]

{ #category : #'gt extensions' }
GtRlProjectsCloneWorkflow >> gtViewRepositoriesCacheFor: aView [
	<gtView>
	^ aView list
		title: 'Repositories Cache';
		priority: 20;
		items: [ repositoriesCacheById values ]
]

{ #category : #initialization }
GtRlProjectsCloneWorkflow >> initialize [
	super initialize.
	loadedProjectsByName := OrderedDictionary new.
	repositoriesCacheById := OrderedDictionary new.
	initialIcebergRepos := OrderedCollection new.
]

{ #category : #initialization }
GtRlProjectsCloneWorkflow >> initializeIcebergRepos [
	initialIcebergRepos addAll: IceRepository registry
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> isBaselineNamedAlreadyLoadedFor: aBaselineName [
	^ loadedProjectsByName includesKey: aBaselineName
]

{ #category : #loading }
GtRlProjectsCloneWorkflow >> loadBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| baselinePackage project |
	
	(self 
		shouldLoadBaselineNamed: aBaselineName 
		fromRepository: aRepositoryLocationString) ifFalse: [ ^ self ].
	self 
		emitLoadStartEventFor: aBaselineName fromRepository: aRepositoryLocationString.
	
	baselinePackage := self 
		loadBaselinePackageFor: aBaselineName 
		fromRepository: aRepositoryLocationString.
	
	project := self 
		createBaselineProjectForPackage: baselinePackage
		fromRepository: aRepositoryLocationString.
	loadedProjectsByName 
		at: aBaselineName
		put: project.
	
	self loadProjectDependenciesFor: project.
	self 
		emitLoadCompletedEventFor: aBaselineName fromRepository: aRepositoryLocationString.
	
	^ project
]

{ #category : #loading }
GtRlProjectsCloneWorkflow >> loadBaselinePackageFor: aBaselineName fromRepository: aRepositoryLocationString [
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
GtRlProjectsCloneWorkflow >> loadProjectDependenciesFor: aBaselineProject [
	aBaselineProject childProjects do: [ :aProject |
		self 
			loadBaseline: aProject name 
			fromRepository: aProject repository urlString ].
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> shouldLoadBaselineNamed: aBaselineName fromRepository: aRepositoryLocationString [
	"Ensure that we can load the baseline without having conflictual repositories 
	or baselines loaded. Throw an error if there is a conflict from which we 
	cannot recover."
	
	self 
		ensureNoConflictWithIcebergRepoFor: aRepositoryLocationString
		forBaseline: aBaselineName.
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
