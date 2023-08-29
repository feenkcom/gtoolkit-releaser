"
I model a repository that contains projects.

I have as main attributes:
	- a load specification that indicates the location of the repository (following the same conventions as Metacello);
	- a list of contained projects. 

I can have indirect child and parent repositories, depending on the relations between the projects that I contain.  
I can be linked to an {{gtClass:IceRepository}} that provides the concrete repository holding the code.


"
Class {
	#name : #GtRlRepository,
	#superclass : #Object,
	#instVars : [
		'loadSpecification',
		'projects',
		'icebergRepository'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlRepository class >> fromUrlString: aString [
	^ self new
		loadSpecification: (GtRlRepositoryLoadSpecification fromUrlString: aString)
]

{ #category : #comparing }
GtRlRepository >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self loadSpecification = anotherObject loadSpecification
]

{ #category : #accessing }
GtRlRepository >> addProject: aFkRlProject [
	projects add: aFkRlProject 
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> childRepositories [ 
	^ (self projects flatCollect: [ :aProject | 
		aProject childProjects collect: #repository ]) removeDuplicates
			remove: self ifAbsent: [ ];
			yourself

]

{ #category : #accessing }
GtRlRepository >> containedPackages [
	^ self projects flatCollect: [ :aProject |
		aProject packages ]
]

{ #category : #ui }
GtRlRepository >> gtBranchesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Branches';
		items: [ self icebergRepository allBranches ];
		itemText: #gtSummaryDescription
]

{ #category : #ui }
GtRlRepository >> gtContainedPackagesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Packages';
		priority: 50;
		items: [ self containedPackages ]
]

{ #category : #ui }
GtRlRepository >> gtProjectsFor: aView [
	<gtView>
	
	^ aView list 
		title: 'Projects';
		items: [ self projects ]
]

{ #category : #ui }
GtRlRepository >> gtRepoDependenciesFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Repo dependencies';
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositories) asSet.
			mondrian nodes 
				shape: [ :aRepository | 
					| text element |
					text := [
						aRepository loadSpecificationString asRopedText ]
						on: Error do: [ :e | e asString asRopedText foreground: BrGlamorousColors linkWithErrorColor ].
					element := BlTextElement new.
					element 	
						text: text; 
						zIndex: 1.];
					with: repos.
				mondrian edges
				shape: [
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.2;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | |dependedRepos |
					dependedRepos := each childRepositories.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradHorizontalDominanceTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #ui }
GtRlRepository >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Repo map';
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositories) asSet.
			mondrian nodes 
				shape: [ :aRepository | 
					| container children label |
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					label := BrLabel new
						text: aRepository loadSpecificationString;
						aptitude: BrGlamorousLabelAptitude;
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					children := BlElement new
						constraintsDo: [ :c | 
							c linear horizontal alignCenter ].
					children graph beChildrenContainer.
					container
						addChild: label;
						addChild: children.
					container ];
				with: repos;
				forEach: [ :aRepository | 
					mondrian nodes
						shape: [ :aProject |
							(BlTextElement text: aProject name asRopedText)
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c linear horizontal alignCenter ]. ];
						with: aRepository projects.
					mondrian layout vertical ].
			mondrian edges
				shape: [
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.2;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | |dependedRepos |
					dependedRepos := each childRepositories.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradWestHierarchicalLayout new)]
]

{ #category : #ui }
GtRlRepository >> gtTagsFor: aView [
	<gtView>
	^ aView list
		title: 'Tags' translated;
		items: [ self icebergRepository tags ];
		itemText:
				[ :anIceTag | anIceTag name , ' [' , (anIceTag commit id first: 7) , ']' ]
]

{ #category : #testing }
GtRlRepository >> hasVersion [
	^ self loadSpecification hasVersion
]

{ #category : #comparing }
GtRlRepository >> hash [ 
	^ self class hash 
		bitXor: self loadSpecification hash
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> icebergRepository [
	"I act like a cache for the iceberg repository associated with this repository."
	^ icebergRepository ifNil: [
		icebergRepository := IceRepository registry detect: [ :anIceRepo | 
			anIceRepo name asLowercase = self repositoryName asLowercase ] ]
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> icebergRepository: aIcebergRepository [
	icebergRepository := aIcebergRepository
]

{ #category : #deprecated }
GtRlRepository >> id [ 	
	^ self loadSpecificationId
]

{ #category : #initialization }
GtRlRepository >> initialize [ 
	super initialize.
	projects := OrderedCollection new.
]

{ #category : #testing }
GtRlRepository >> isLeaf [
	^ self childRepositories isEmpty
]

{ #category : #'accessing - load specification' }
GtRlRepository >> loadSpecification [
	^ loadSpecification
]

{ #category : #'accessing - load specification' }
GtRlRepository >> loadSpecification: aRepositoryLoadSpecification [
	self assert: [ aRepositoryLoadSpecification notNil ].
	
	loadSpecification := aRepositoryLoadSpecification
]

{ #category : #'accessing - load specification' }
GtRlRepository >> loadSpecificationId [
	^ self loadSpecification specificationId
]

{ #category : #'accessing - load specification' }
GtRlRepository >> loadSpecificationString [
	^ self loadSpecification specificationString
]

{ #category : #'accessing - load specification' }
GtRlRepository >> loadSpecificationUrl [
	^ self loadSpecification specificationUrl
]

{ #category : #'accessing - load specification' }
GtRlRepository >> nameSegment [
	^ self loadSpecification nameSegment
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> parentRepositories [ 
	^ (projects flatCollect: [ :aProject | 
		aProject parentProjects collect: #repository]) asSet
			remove: self ifAbsent: [ ];
			yourself
	
]

{ #category : #printing }
GtRlRepository >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self loadSpecificationString;
		nextPutAll: ')'
]

{ #category : #'accessing - load specification' }
GtRlRepository >> projectName [
	^ self loadSpecification projectName
]

{ #category : #accessing }
GtRlRepository >> projects [ 
	^ projects
]

{ #category : #'accessing - load specification' }
GtRlRepository >> repositoryName [
	^ self loadSpecification repositoryName
]

{ #category : #deprecated }
GtRlRepository >> url [
	^ self loadSpecificationUrl
]

{ #category : #deprecated }
GtRlRepository >> urlString [
	^ self loadSpecificationString
]

{ #category : #'accessing - load specification' }
GtRlRepository >> urlWithVersion: aVersionString [
	^ self loadSpecification urlWithVersion: aVersionString
]

{ #category : #'accessing - load specification' }
GtRlRepository >> versionString [
	^ self loadSpecification versionString
]

{ #category : #'accessing - load specification' }
GtRlRepository >> versionStringOrNil [
	^ self loadSpecification versionStringOrNil
]
