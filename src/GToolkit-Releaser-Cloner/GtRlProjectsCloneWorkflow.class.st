"
I implement the main logic for clonning a baseline specification together with all its dependencies.

I start from a main baseline, clone its repository, and then recursively iterate over and close its dependencies. I do not load any code appart from baselines.
I currently raise errros when I detect conflictual situations. I do not try to recover not currently provide any way to handle conflicts. See {{gtMethod:GtRlProjectsCloneWorkflow>>#shouldLoadBaselineSpec:}} for what checks are performed before cloning and loading a baseline specification.


"
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
GtRlProjectsCloneWorkflow >> createBaselineProjectForPackage: baselinePackage fromSpec: aBaselineSpec [
	| baselineClassName baselineClass |
	baselineClassName := baselinePackage name.
	baselineClass := baselinePackage classes
		detect: [ :each | each name = baselineClassName ].
	
	^ GtRlLocalDependenciesModelBuilder new
		buildProjectFromBaselineClass: baselineClass
		withRepositoryDescription: aBaselineSpec repositoryLocation.
	
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> defaultBranchName [
	^ 'master'
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitBaselineAlreadyLoadedForSpec: aBaselineSpec [
	GtRlClonerBaselineSkipLoadSignal new
		baselineName: aBaselineSpec baselineName;
		repositoryUrlString: aBaselineSpec repositoryLocation;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitLoadCompletedEventForSpec: aBaselineSpec [
	GtRlClonerBaselineLoadCompletedSignal new
		baselineName: aBaselineSpec baselineName;
		repositoryUrlString: aBaselineSpec repositoryLocation;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitLoadStartEventForSpec: aBaselineSpec [
	GtRlClonerBaselineLoadStartedSignal new
		baselineName: aBaselineSpec baselineName;
		repositoryUrlString: aBaselineSpec repositoryLocation;
		emit
]

{ #category : #logging }
GtRlProjectsCloneWorkflow >> emitPackageLoadForSpec: aBaselineSpec [
	GtRlClonerBaselinePackageLoadSignal new
		baselineName: aBaselineSpec baselineName;
		repositoryUrlString: aBaselineSpec repositoryLocation;
		emit
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> ensureNoConflictWithIcebergRepoForSpec: aBaselineSpec [
	| toLoadRepository icebergRepo repoVersion |
	toLoadRepository := GtRlRepository 
		fromUrlString: aBaselineSpec repositoryLocation.
	
	icebergRepo := initialIcebergRepos  
		detect: [ :anIcebergRepo | 
			anIcebergRepo name asLowercase = toLoadRepository repositoryName asLowercase ]
		ifNone: [ ^ self ].
		
	((icebergRepo isMissing) or: [ 
		(icebergRepo hasRemoteNamed: 'origin') not ]) ifTrue: [ 
			Error signal: ('Iceberg repo ({1}) is missing origin. Not supported currently!' format: { icebergRepo name }) ].
	
	(toLoadRepository projectPath = icebergRepo origin projectPath) ifFalse: [
		GtRlClonerIcebergRepoMismatchError new 
			baselineSpec: aBaselineSpec;
			mismatchType: 'Project Path';
			baselineData: toLoadRepository projectPath;
			icebergData: icebergRepo origin projectPath;
			signal ].
	
	(toLoadRepository repoPath = icebergRepo subdirectory) ifFalse: [
		GtRlClonerIcebergRepoMismatchError new 
			baselineSpec: aBaselineSpec;
			mismatchType: 'Repo Path';
			baselineData: toLoadRepository repoPath;
			icebergData: icebergRepo subdirectory;
			signal ].
	
	repoVersion := toLoadRepository versionStringOrNil 
		ifNil: [ self defaultBranchName ].
	(repoVersion = icebergRepo head gtClonerVersionDescription) ifFalse: [
		GtRlClonerIcebergRepoMismatchError new 
			baselineSpec: aBaselineSpec;
			mismatchType: 'Baseline Version';
			baselineData: repoVersion;
			icebergData: icebergRepo head gtClonerVersionDescription;
			signal ].
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
GtRlProjectsCloneWorkflow >> ensureSameRepositoryForBaselineSpec: aBaselineSpec [
	| loadedProject |
	(loadedProjectsByName includesKey: aBaselineSpec baselineName) ifFalse: [ ^ self ].
	
	loadedProject := loadedProjectsByName at: aBaselineSpec baselineName.
	(loadedProject repository loadSpecificationString = aBaselineSpec repositoryLocation) ifFalse: [ 
		GtRlClonerDifferentBaselineRepositoryError new
			baselineSpec: aBaselineSpec;
			loadedProject: loadedProject;
			signal ]
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> ensureSingleRepositoryVersionForSpec: aBaselineSpec [
	| toLoadRepository loadedRepository  |
	
	"This is a hack as we are missing a url model. So we create
	and use a temporary repository to work with urls."
	toLoadRepository := GtRlRepository 
		fromUrlString: aBaselineSpec repositoryLocation.
	
	(repositoriesCacheById includesKey: toLoadRepository id asLowercase) 
		ifFalse: [ ^ self ].

	loadedRepository := repositoriesCacheById at: toLoadRepository id asLowercase.
	"In case we try to load two different versions for the same repository
	we raise an error."
	(loadedRepository versionStringOrNil = toLoadRepository versionStringOrNil) ifFalse: [ 
		GtRlClonerDifferentRepositoryVersionError new
			baselineSpec: aBaselineSpec;
			loadedVersionString: loadedRepository versionStringOrNil;
			newVersionString: toLoadRepository versionStringOrNil;
			signal ] 
]

{ #category : #'gt extensions' }
GtRlProjectsCloneWorkflow >> gtViewLoadedProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Loaded projects';
		priority: 15;
		items: [ loadedProjectsByName values ]
]

{ #category : #'gt extensions' }
GtRlProjectsCloneWorkflow >> gtViewRepositoriesCacheFor: aView [
	<gtView>
	^ aView list
		title: 'Repositories cache';
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
GtRlProjectsCloneWorkflow >> isBaselineNamedAlreadyLoadedForSpec: aBaselineSpec [
	^ loadedProjectsByName includesKey: aBaselineSpec baselineName
]

{ #category : #loading }
GtRlProjectsCloneWorkflow >> loadBaselinePackageForSpec: aBaselineSpec [
	| icebergRepository icebergPackage baselineClassName |
	baselineClassName := MetacelloScriptEngine 
		baselineNameFrom: aBaselineSpec baselineName.
	
	icebergRepository := self ensureRepositoryCloneFor: aBaselineSpec repositoryLocation.
	(icebergRepository workingCopy packageNames 
		includes: baselineClassName)
			ifFalse: [ Error signal: 'Cannot find baseline package ', baselineClassName ].
	
	self emitPackageLoadForSpec: aBaselineSpec.
	icebergPackage := icebergRepository workingCopy packageNamed: baselineClassName.
	icebergPackage load.
	
	^ self class packageOrganizer
		packageNamed: icebergPackage name
]

{ #category : #loading }
GtRlProjectsCloneWorkflow >> loadBaselineSpec: aBaselineSpec [
	| baselinePackage project |
	
	(self shouldLoadBaselineSpec: aBaselineSpec) ifFalse: [ ^ self ].
	
	self emitLoadStartEventForSpec: aBaselineSpec.
	baselinePackage := self loadBaselinePackageForSpec: aBaselineSpec.
	
	project := self 
		createBaselineProjectForPackage: baselinePackage
		fromSpec: aBaselineSpec.
	loadedProjectsByName 
		at: aBaselineSpec baselineName
		put: project.
	
	self loadProjectDependenciesFor: project.
	self emitLoadCompletedEventForSpec: aBaselineSpec.
	
	^ project
]

{ #category : #loading }
GtRlProjectsCloneWorkflow >> loadProjectDependenciesFor: aBaselineProject [
	aBaselineProject childProjects do: [ :aProject |
		self 
			loadBaselineSpec: (GtRlClonerBaselineSpec new
				baselineName: aProject name;
				repositoryLocation: aProject repository loadSpecificationString) ].
]

{ #category : #testing }
GtRlProjectsCloneWorkflow >> shouldLoadBaselineSpec: aBaselineSpec [
	"Ensure that we can load the baseline without having conflictual repositories 
	or baselines loaded. Throw an error if there is a conflict from which we 
	cannot recover."
	
	self ensureNoConflictWithIcebergRepoForSpec: aBaselineSpec.
	self ensureSingleRepositoryVersionForSpec: aBaselineSpec.
	self ensureSameRepositoryForBaselineSpec: aBaselineSpec.
		
	(self isBaselineNamedAlreadyLoadedForSpec: aBaselineSpec) ifTrue: [
		self emitBaselineAlreadyLoadedForSpec: aBaselineSpec.
		^ false].

	^ true
]
