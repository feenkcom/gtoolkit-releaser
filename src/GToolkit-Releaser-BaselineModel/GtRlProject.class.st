Class {
	#name : #GtRlProject,
	#superclass : #GtRlNode,
	#instVars : [
		'name',
		'baselineVersion',
		'baselineClass',
		'repository',
		'parentProjects',
		'childProjects',
		'packages',
		'preLoadAction',
		'postLoadAction'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #examples }
GtRlProject class >> changeBaselinesThenTagEachRepo [
	| semanticVersion |
	semanticVersion := self findNextGToolkitVersion printString.
	self gitRepositories keysAndValuesDo: [ :key :collection | 
		| repository releaseBranch |
		"switch to release branch"
		repository := IceRepository registry detect: [ :r | 
			(key includesSubstring: ('/', r name, '/')) or: (key includesSubstring: ('/', r name, ':')) ].
		repository checkoutBranch: 'release'.
		releaseBranch := repository branchNamed: 'release'.
		"do the merge from master"
		IceMerge new 
			repository: repository; 
			mergeCommit: (repository branchNamed:'master') commit; 
			executeWithAcceptingLeftOnConflict.
	
		"do the baseline change"
		collection do: [ :aFkRlProject |
			| baselineMethodSourceCode |
			baselineMethodSourceCode := self generateVersionBaselineForClass: (aFkRlProject baselineClass) withRepoDescription: aFkRlProject name withTag: semanticVersion.
			aFkRlProject baselineClass compile: baselineMethodSourceCode. 
		].
		
		"commit, tag and push to origin"
		repository workingCopy  commitChanges: repository workingCopyDiff withMessage: 'update baseline' force: true.
		releaseBranch commit ensureCreateTag: semanticVersion.
		(repository checkoutBranch: 'release') pushTo: (repository remotes detect: [:r | r name = #origin]).
	].
	^ self gitRepositories	

]

{ #category : #examples }
GtRlProject class >> findNextFkRlSemanticVersion: aBranch [
	| allTags semanticVersionTags result |
	result := GtRlSemanticVersionNumber new major:0; minor: 2; patch: 0.
	allTags := (aBranch commit withDeepCollect: #ancestors) flatCollect: #tags. 
	semanticVersionTags := allTags select: [ :t | t name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ].
	(semanticVersionTags collect:  [ :each | 
		|tokens| 
		tokens := each name findTokens: '.'. 
		GtRlSemanticVersionNumber new major: tokens first asInteger; minor: tokens second asInteger; patch: tokens third asInteger]) 
			ifNotEmpty:[ :c | ^ c sort last incrementPatch  ] 
			ifEmpty: [ ^ result ].




]

{ #category : #examples }
GtRlProject class >> findNextGToolkitVersion [
	| allVersions |
	allVersions := OrderedCollection new.
	allVersions add: (GtRlSemanticVersionNumber new major:0; minor: 2; patch: 0).
	self gitRepositories keysAndValuesDo: [ :key :collection | 
		| repository semanticVersion releaseBranch |
		"switch to release branch"
		repository := IceRepository registry detect: [ :r | 
			(key includesSubstring: ('/', r name, '/')) or: (key includesSubstring: ('/', r name, ':')) ].
		repository checkoutBranch: 'release'.
		releaseBranch := repository branchNamed: 'release'.
		"get compute the latest version"
		semanticVersion := self findNextFkRlSemanticVersion: releaseBranch.	
		allVersions add: semanticVersion. 
	].
	^ allVersions sort last.

]

{ #category : #examples }
GtRlProject class >> findNextSemanticVersion: aBranch [
	| allTags semanticVersionTags result |
	result := '0.2.0'.
	allTags := (aBranch commit withDeepCollect: #ancestors) flatCollect: #tags. 
	semanticVersionTags := allTags select: [ :t | t name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ].
	(semanticVersionTags collect:  [ :each | 
		|tokens| 
		tokens := each name findTokens: '.'. 
		GtRlSemanticVersionNumber new major: tokens first asInteger; minor: tokens second asInteger; patch: tokens third asInteger]) 
			ifNotEmpty:[ :c | ^ c sort last incrementPatch printString ] 
			ifEmpty: [ ^ result ].




]

{ #category : #examples }
GtRlProject class >> generateVersionBaselineForClass: aBaselineClass withRepoDescription: aRepoDescription withTag: aSemanticVersion [
	| project builder |
	builder := GtRlModelBuilder new.
	project := builder 
		buildProjectFromBaselineClass: aBaselineClass
		withRepositoryDescription: aRepoDescription.
	^ project generateSourceWithSemanticVersion: aSemanticVersion.
]

{ #category : #examples }
GtRlProject class >> gitRepositories [
	| project builder repoToBaselinesMap allProjects |
	builder := GtRlModelBuilder new.
	repoToBaselinesMap := IdentityDictionary new.
	project := builder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit/src'.
	allProjects := (project withDeepCollect: #childProjects).
	(allProjects select: #isGToolkitProject) do:[ :each |
		repoToBaselinesMap at: (each githubRepoURL asSymbol) 
			ifPresent: [ :collection | (repoToBaselinesMap at: (each githubRepoURL asSymbol)) add: each  ] 
			ifAbsentPut: [ |c| c := OrderedCollection new. c add: each. c  ].
		].
	^ repoToBaselinesMap.

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

{ #category : #'accessing - dynamic' }
GtRlProject >> allChildrenProjects [
	^ self withDeepCollect: #childProjects 
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

{ #category : #'accessing - dynamic' }
GtRlProject >> childProjectsNames [
	^ self childProjects collect: #name
]

{ #category : #actions }
GtRlProject >> compileBaselineWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox commitBaselineOfMethod.
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
	^ self baselineVersion ifNotNil: [ :aBaselineVersion |
		(aBaselineVersion gtProjectMapFor: aView)
			title: 'MC Map';
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
		priority: 60;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProject |
					BlTextElement new text: aProject name asRopedText ];
				with: self allChildrenProjects.
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
			mondrian layout horizontalDominanceTree 
				nodeDistance: 10; 
				levelDistance: 10 ]
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
	^ aView textEditor
		title: 'Source' translated;
		text: [ String streamContents: [ :s | 
			self baselineVersion spec configMethodOn: s] ];
		priority: 55
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

{ #category : #actions }
GtRlProject >> linkWithRepository: aRepository [
	self repository: aRepository.
	aRepository addProject: self
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
	^ postLoadAction
]

{ #category : #accessing }
GtRlProject >> postLoadAction: aSymbol [
	postLoadAction := aSymbol
]

{ #category : #accessing }
GtRlProject >> preLoadAction [
	^ preLoadAction
]

{ #category : #accessing }
GtRlProject >> preLoadAction: aSymbol [
	preLoadAction := aSymbol
]

{ #category : #printing }
GtRlProject >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self name.
	aStream nextPutAll: ')'
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
  toolbox := (GtRlMetacelloToolBox baselineNamed: self baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
	addBaselineOfSection: #'common'
		requiredProjects: projectNames
	   packages: (self packages collect: #name)
	   dependencies: (self packages collect: [ :aPackage | 
			aPackage name -> aPackage dependencies ])
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
