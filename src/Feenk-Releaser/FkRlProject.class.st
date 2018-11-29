Class {
	#name : #FkRlProject,
	#superclass : #FkRlNode,
	#instVars : [
		'name',
		'baselineVersion',
		'baselineClass',
		'repository',
		'parentProjects',
		'childProjects',
		'packages'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #examples }
FkRlProject class >> changeBaselinesThenTagEachRepo [
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
			executeWithoutUpdatingWorkingCopy.
	
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
FkRlProject class >> findNextFkRlSemanticVersion: aBranch [
	| allTags semanticVersionTags result |
	result := FkRlSemanticVersion new major:0; minor: 2; patch: 0.
	allTags := (aBranch commit withDeepCollect: #ancestors) flatCollect: #tags. 
	semanticVersionTags := allTags select: [ :t | t name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ].
	(semanticVersionTags collect:  [ :each | 
		|tokens| 
		tokens := each name findTokens: '.'. 
		FkRlSemanticVersion new major: tokens first asInteger; minor: tokens second asInteger; patch: tokens third asInteger]) 
			ifNotEmpty:[ :c | ^ c sort last incrementPatch  ] 
			ifEmpty: [ ^ result ].




]

{ #category : #examples }
FkRlProject class >> findNextGToolkitVersion [
	| allVersions |
	allVersions := OrderedCollection new.
	allVersions add: (FkRlSemanticVersion new major:0; minor: 2; patch: 0).
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
FkRlProject class >> findNextSemanticVersion: aBranch [
	| allTags semanticVersionTags result |
	result := '0.2.0'.
	allTags := (aBranch commit withDeepCollect: #ancestors) flatCollect: #tags. 
	semanticVersionTags := allTags select: [ :t | t name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ].
	(semanticVersionTags collect:  [ :each | 
		|tokens| 
		tokens := each name findTokens: '.'. 
		FkRlSemanticVersion new major: tokens first asInteger; minor: tokens second asInteger; patch: tokens third asInteger]) 
			ifNotEmpty:[ :c | ^ c sort last incrementPatch printString ] 
			ifEmpty: [ ^ result ].




]

{ #category : #examples }
FkRlProject class >> generateVersionBaselineForClass: aBaselineClass withRepoDescription: aRepoDescription withTag: aSemanticVersion [
	| project builder |
	builder := FkRlModelBuilder new.
	project := builder 
		buildProjectFromBaselineClass: aBaselineClass
		withRepositoryDescription: aRepoDescription.
	^ project generateSourceWithSemanticVersion: aSemanticVersion.
]

{ #category : #examples }
FkRlProject class >> gitRepositories [
	| project builder repoToBaselinesMap allProjects |
	builder := FkRlModelBuilder new.
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
FkRlProject >> addChildProject: aChildProject [ 
	self childProjects add: aChildProject.
	aChildProject basicAddParentProject: self
]

{ #category : #adding }
FkRlProject >> addChildProjects: aCollection [
	aCollection do: [ :aChildProject | 
		self addChildProject: aChildProject ]
]

{ #category : #adding }
FkRlProject >> addPackage: aPackage [
	aPackage parentProject: self. 
	self packages add: aPackage.
]

{ #category : #adding }
FkRlProject >> addPackages: aCollection [
	aCollection do: [ :aPackage |
		self addPackage: aPackage ]
]

{ #category : #'accessing - dynamic' }
FkRlProject >> allChildrenProjects [
	^ self withDeepCollect: #childProjects 
]

{ #category : #accessing }
FkRlProject >> baselineClass [
	^ baselineClass
]

{ #category : #accessing }
FkRlProject >> baselineClass: aBaselineClass [
	baselineClass := aBaselineClass
]

{ #category : #accessing }
FkRlProject >> baselineVersion [
	^ baselineVersion
]

{ #category : #accessing }
FkRlProject >> baselineVersion: aMetacelloVersion [
	self assert: [ aMetacelloVersion name = 'baseline' ].
	self assert: [ aMetacelloVersion versionNumber versionString = 'baseline' ].
	baselineVersion := aMetacelloVersion
]

{ #category : #private }
FkRlProject >> basicAddParentProject: aParentProject [
	self parentProjects add: aParentProject
]

{ #category : #accessing }
FkRlProject >> childProjects [
	^ childProjects
]

{ #category : #'accessing - dynamic' }
FkRlProject >> childProjectsNames [
	^ self childProjects collect: #name
]

{ #category : #actions }
FkRlProject >> compileBaselineWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox commitBaselineOfMethod.
]

{ #category : #actions }
FkRlProject >> generateSourceWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox methodSpec methodSource
]

{ #category : #ui }
FkRlProject >> gtChildProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Child Projects' translated;
		items: [ self childProjects ];
		itemFormat: #name;
		priority: 45
]

{ #category : #ui }
FkRlProject >> gtMCProjectMapFor: aView [
	<gtView>
	^ self baselineVersion ifNotNil: [ :aBaselineVersion |
		(aBaselineVersion gtProjectMapFor: aView)
			title: 'MC Map';
			priority: 70 ]
]

{ #category : #ui }
FkRlProject >> gtParentProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Parent Projects' translated;
		items: [ self parentProjects ];
		itemFormat: #name;
		priority: 50
]

{ #category : #ui }
FkRlProject >> gtProjectMapFor: aView [
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
FkRlProject >> gtRepoMapFor: aView [
	<gtView> 
	^ self repository 
		ifNil: [ aView ]
		ifNotNil:  [ :aRepository | 
			(aRepository gtRepoMapFor: aView)
				priority: 60 ]
]

{ #category : #ui }
FkRlProject >> gtSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Source' translated;
		text: [ String streamContents: [ :s | 
			self baselineVersion spec configMethodOn: s] ];
		priority: 55
]

{ #category : #initialization }
FkRlProject >> initialize [ 
	super initialize.
	packages := OrderedCollection new.
	parentProjects := OrderedCollection new.
	childProjects := OrderedCollection new
]

{ #category : #actions }
FkRlProject >> linkWithRepository: aRepository [
	self repository: aRepository.
	aRepository addProject: self
]

{ #category : #accessing }
FkRlProject >> name [ 	
	^ name
]

{ #category : #accessing }
FkRlProject >> name: aString [
	name := aString
]

{ #category : #accessing }
FkRlProject >> packages [
	^ packages
]

{ #category : #accessing }
FkRlProject >> parentProjects [
	^ parentProjects
]

{ #category : #printing }
FkRlProject >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self name.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
FkRlProject >> repository [
	^ repository
]

{ #category : #accessing }
FkRlProject >> repository: aRepository [
	repository := aRepository 
]

{ #category : #private }
FkRlProject >> toolboxForBaselineWithProjectDependencies: projectDependenciesMap [
	| projectNames  |
	projectNames := projectDependenciesMap collect: #key.
  ^ (FkRlMetacelloToolBox baselineNamed: self baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
    addBaselineOfSection: #'common'
      requiredProjects: projectNames
      packages: (self packages collect: #name)
      repositories: projectDependenciesMap
      dependencies: (self packages collect: [ :aPackage | 
			aPackage name -> aPackage dependencies ])
      groups: #()
      versionSpecsDo: [ :versionSpec | ]
]
