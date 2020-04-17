"
I model a project that resides within a repository, has dependencies to other projects and loads certain packages from the repository. I correspond to a Monticello baseline.

I have as main attributes: 
	- the name of the project
	- the list of packages loaded by the project 
	- the repositry containing the project 
	- a list of child and parent projects representing my dependencies to other projects
"
Class {
	#name : #GtRlProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'baselineVersion',
		'baselineClass',
		'repository',
		'parentProjects',
		'childProjects',
		'packages',
		'preLoadAction',
		'postLoadAction',
		'metacelloToolbox'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlProject class >> withName: projectName [
	^ self new
		name: projectName
]

{ #category : #adding }
GtRlProject >> addChildProject: aChildProject [ 
	self childProjects add: aChildProject.
	aChildProject basicAddParentProject: self
]

{ #category : #adding }
GtRlProject >> addChildProjects: aCollection [
	aCollection do: [ :aChildProject | 
		self addChildProject: aChildProject ]
]

{ #category : #adding }
GtRlProject >> addPackage: aPackage [
	aPackage parentProject: self. 
	self packages add: aPackage.
]

{ #category : #adding }
GtRlProject >> addPackages: aCollection [
	aCollection do: [ :aPackage |
		self addPackage: aPackage ]
]

{ #category : #accessing }
GtRlProject >> baselineClass [
	^ baselineClass
]

{ #category : #accessing }
GtRlProject >> baselineClass: aBaselineClass [
	baselineClass := aBaselineClass
]

{ #category : #accessing }
GtRlProject >> baselineVersion [
	^ baselineVersion
]

{ #category : #accessing }
GtRlProject >> baselineVersion: aMetacelloVersion [
	self assert: [ aMetacelloVersion name = 'baseline' ].
	self assert: [ aMetacelloVersion versionNumber versionString = 'baseline' ].
	baselineVersion := aMetacelloVersion.
	
	aMetacelloVersion spec preLoadDoIt ifNotNil: [ :aPreLoadSpec |
		self 
			assert: [ aPreLoadSpec isKindOf: MetacelloValueHolderSpec ] 
			description: 'Only MetacelloValueHolderSpec are supported as pre load actions'.
		self preLoadAction: aPreLoadSpec value ].
	aMetacelloVersion spec postLoadDoIt ifNotNil: [ :aPostLoadSpec |
		self 
			assert: [ aPostLoadSpec isKindOf: MetacelloValueHolderSpec ] 
			description: 'Only MetacelloValueHolderSpec are supported as post load actions'.
		self postLoadAction: aPostLoadSpec value ]
]

{ #category : #private }
GtRlProject >> basicAddParentProject: aParentProject [
	self parentProjects add: aParentProject
]

{ #category : #accessing }
GtRlProject >> childProjects [
	^ childProjects
]

{ #category : #actions }
GtRlProject >> compileBaselineWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox commitBaselineOfMethod.
]

{ #category : #traversing }
GtRlProject >> containedRPackagesDo: aBloc [
	self packages do: [ :aReleaserPackage |
		(RPackageOrganizer default 
			packageNamed: aReleaserPackage name 
			ifAbsent: [nil]) ifNotNil: [ :aRPackage | 
				aBloc value: aRPackage ] ]
]

{ #category : #actions }
GtRlProject >> generateSourceWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox methodSpec methodSource
]

{ #category : #ui }
GtRlProject >> gtChildProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Child Projects' translated;
		items: [ self childProjects ];
		itemFormat: #name;
		priority: 45
]

{ #category : #ui }
GtRlProject >> gtMCProjectMapFor: aView [
	<gtView>
	^ self baselineVersion 
		ifNil: [ aView ]
		ifNotNil: [ :aBaselineVersion |
			(aBaselineVersion gtProjectMapFor: aView)
				title: 'MC Map' translated;
				priority: 70 ]
]

{ #category : #ui }
GtRlProject >> gtParentProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Parent Projects' translated;
		items: [ self parentProjects ];
		itemFormat: #name;
		priority: 50
]

{ #category : #ui }
GtRlProject >> gtProjectMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 1;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProject |
					BlTextElement new text: aProject name asRopedText ];
				with: self withAllChildProjects.
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childProjects.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #ui }
GtRlProject >> gtRepoMapFor: aView [
	<gtView> 
	^ self repository 
		ifNil: [ aView ]
		ifNotNil:  [ :aRepository | 
			(aRepository gtRepoMapFor: aView)
				priority: 60 ]
]

{ #category : #ui }
GtRlProject >> gtSourceFor: aView [
	<gtView> 
	self baselineVersion ifNil: [ ^ aView ].
	^ aView textEditor
		title: 'Source' translated;
		text: [ String streamContents: [ :s | 
			self baselineVersion spec configMethodOn: s] ];
		priority: 55
]

{ #category : #ui }
GtRlProject >> gtViewRepositoriesListFor: aView [
	<gtView>
	^ aView list
		title: 'Packages' translated;
		items: [ self packages ];
		itemFormat: #name;
		priority: 60
]

{ #category : #initialization }
GtRlProject >> initialize [ 
	super initialize.
	packages := OrderedCollection new.
	parentProjects := OrderedCollection new.
	childProjects := OrderedCollection new
]

{ #category : #testing }
GtRlProject >> isLeaf [
	^ self childProjects isEmpty
]

{ #category : #testing }
GtRlProject >> isPackageNode [
	"Hack to be compatible with ProjectReference"
	^ false
]

{ #category : #testing }
GtRlProject >> isProjectReference [
	"Hack to be compatible with ProjectReference"
	^ true
]

{ #category : #actions }
GtRlProject >> linkWithRepository: aRepository [
	self repository: aRepository.
	(GtRlProjectLinkWithRepositorySignal project: self repository: aRepository) emit.
	aRepository addProject: self
]

{ #category : #accessing }
GtRlProject >> metacelloToolbox [
	^ metacelloToolbox ifNil: [ GtRlMetacelloToolBox new ]
]

{ #category : #accessing }
GtRlProject >> metacelloToolbox: aMetacelloToolbox [
	"This only exists to make tests work without loading the baseline for tests packages."
	metacelloToolbox := aMetacelloToolbox
]

{ #category : #accessing }
GtRlProject >> name [ 	
	^ name
]

{ #category : #accessing }
GtRlProject >> name: aString [
	name := aString
]

{ #category : #accessing }
GtRlProject >> packages [
	^ packages
]

{ #category : #accessing }
GtRlProject >> parentProjects [
	^ parentProjects
]

{ #category : #accessing }
GtRlProject >> postLoadAction [
	"Return the action for executing after the project was loaded.
	${example:GtRlProjectExamples>>#projectWithPostLoadAction}$
	"
	^ postLoadAction
]

{ #category : #accessing }
GtRlProject >> postLoadAction: aSymbol [
	"Set a selector existing in the baseline class that will be executed after the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPostLoadAction}$"
	postLoadAction := aSymbol
]

{ #category : #accessing }
GtRlProject >> preLoadAction [
	"Return the action for executing before the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPreLoadAction}$"
	^ preLoadAction
]

{ #category : #accessing }
GtRlProject >> preLoadAction: aSymbol [
	"Set a selector existing in the baseline class that will be executed after the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPreLoadAction}$"
	preLoadAction := aSymbol
]

{ #category : #printing }
GtRlProject >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlProject >> repository [
	^ repository
]

{ #category : #accessing }
GtRlProject >> repository: aRepository [
	repository := aRepository 
]

{ #category : #private }
GtRlProject >> toolboxForBaselineWithProjectDependencies: projectDependenciesMap [
	| projectNames toolbox |
	projectNames := projectDependenciesMap collect: #key.

   toolbox := (self metacelloToolbox 
	 baselineNamed: self baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
	addBaselineOfSection: #'common'
		requiredProjects: projectNames
	   packages: (self packages collect: #name)
	   dependencies: (self packages collect: [ :aPackage | 
			aPackage name -> (aPackage requiredNodes collect: #name) ])
	   includes: #()
	   files: #()
	   repositories: projectDependenciesMap
	   preLoadDoIts: #()
	   postLoadDoIts: #()
	   supplyingAnswers: #()
	   groups: #()
	   versionSpecsDo: [ :versionSpec | ].
	
	self assert: [ toolbox methodSpec methodSections size = 1] description: 'Only one section per method is supported'.
	self assert: [ toolbox methodSpec methodSections first attributes = #(#common) ] description: 'Only #common section is supported'.
	self preLoadAction ifNotNil: [ 
		toolbox methodSpec methodSections first versionSpec preLoadDoIt: self preLoadAction ].
	 self postLoadAction ifNotNil: [
		toolbox methodSpec methodSections first versionSpec postLoadDoIt: self postLoadAction ].
	
	^ toolbox
]

{ #category : #traversing }
GtRlProject >> withAllChildProjects [
	^ self withDeepCollect: #childProjects
]

{ #category : #'accessing - dynamic' }
GtRlProject >> withAllRepositories [
	"Return all repositores that can be reached from the this project, 
	including the repository holding this project."
	^ (self withDeep: #childProjects  collect: #repository) removeDuplicates
]
