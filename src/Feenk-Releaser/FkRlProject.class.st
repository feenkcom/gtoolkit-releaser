Class {
	#name : #FkRlProject,
	#superclass : #FkRlNode,
	#instVars : [
		'name',
		'baselineVersion',
		'baselineClass',
		'repositorySpec',
		'parentProjects',
		'childProjects',
		'packages'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #examples }
FkRlProject class >> codeGeneration [
	| project builder |
	builder := FkRlModelBuilder new.
	project := builder 
		buildProjectFromBaselineClass: BaselineOfGToolkitDebugger
		withRepositoryDescription: 'github://feenkcom/gtoolkit-debugger/src'.
	^ project generateSource.
]

{ #category : #examples }
FkRlProject class >> gitRepositories [
	| project builder allGitRepos |
	builder := FkRlModelBuilder new.
	project := builder 
		buildProjectFromBaselineClass: BaselineOfGToolkitDebugger
		withRepositoryDescription: 'github://feenkcom/gtoolkit-debugger/src'.
	^ (((((allGitRepos := project withDeepCollect: #childProjects) 
		collect: #repositorySpec) 
			flatCollect: #list) 
				collect: #name) asSet)
					select: [ :repo | repo includesSubstring: 'github://feenkcom/gtoolkit'].
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
	^ self 
		withDeepCollect: [ :aProject | aProject childProjects ] 
		as: Set
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

{ #category : #'private - adding' }
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

{ #category : #'accessing - dynamic' }
FkRlProject >> childProjectsWithNewRepositories [
	^ self childProjects collect: [ :aProject |
		| simpleName currentUrl |
		simpleName := aProject name.
		currentUrl := ZnUrl fromString: aProject repositorySpec list first name.
		currentUrl segments at: 1 put: (currentUrl segments at: 1), ':v1.1.1'. 
		simpleName -> {currentUrl printString} ]
]

{ #category : #'accessing - dynamic' }
FkRlProject >> childProjectsWithNewRepositories: aSemanticVersionString [
	^ self childProjects collect: [ :aProject |
		| simpleName currentUrl |
		simpleName := aProject name.
		currentUrl := ZnUrl fromString: aProject repositorySpec list first name.
		currentUrl segments at: 1 put: (currentUrl segments at: 1), aSemanticVersionString. 
		simpleName -> {currentUrl printString} ]
]

{ #category : #actions }
FkRlProject >> generateSource [
	| toolbox saurce |
  (toolbox := FkRlMetacelloToolBox baselineNamed: self baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
    addBaselineOfSection: #'common'
      requiredProjects: self childProjectsNames
      packages: (self packages collect: #name)
      repositories: self childProjectsWithNewRepositories
      dependencies: (self packages collect: [ :aPackage | 
			aPackage name -> aPackage dependencies ])
      groups: #()
      versionSpecsDo: [ :versionSpec | ].
	saurce := (toolbox methodSpec methodSource).
  ^ saurce
]

{ #category : #actions }
FkRlProject >> generateSourceWithSemanticVersion: aSemanticVersionString [
	| toolbox |
  (toolbox := FkRlMetacelloToolBox baselineNamed: self baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
    addBaselineOfSection: #'common'
      requiredProjects: self childProjectsNames
      packages: (self packages collect: #name)
      repositories: (self childProjectsWithNewRepositories: aSemanticVersionString)
      dependencies: (self packages collect: [ :aPackage | 
			aPackage name -> aPackage dependencies ])
      groups: #()
      versionSpecsDo: [ :versionSpec | ].
  ^ (toolbox methodSpec methodSource).
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

{ #category : #printing }
FkRlProject >> gtDisplayOn: aStream [
	aStream 
		nextPutAll: self name
]

{ #category : #ui }
FkRlProject >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Src (generated)';
		text: [ self generateSource ];
		priority: 55
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

{ #category : #initialization }
FkRlProject >> initialize [ 
	super initialize.
	packages := OrderedCollection new.
	parentProjects := OrderedCollection new.
	childProjects := OrderedCollection new
]

{ #category : #'accessing - dynamic' }
FkRlProject >> name [ 	
	^ name
]

{ #category : #'accessing - dynamic' }
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
	aStream nextPutAll: ' ('.
	self gtDisplayOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
FkRlProject >> repositorySpec [
	^ repositorySpec
]

{ #category : #accessing }
FkRlProject >> repositorySpec: aRepositorySpec [
	repositorySpec := aRepositorySpec 
]
