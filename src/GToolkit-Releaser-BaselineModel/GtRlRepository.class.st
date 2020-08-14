"
I model a repository that contains projects.

I have as main attributes:
	- an url used to identify the repository, following the same conventions as Metacello;
	- a list of contained projects. 

I can have indirect child and parent repositories, depending on the relations between the projects that I contain.  
I can be linked to an ${class:IceRepository}$ that provides the concrete repository holding the code.
"
Class {
	#name : #GtRlRepository,
	#superclass : #Object,
	#instVars : [
		'url',
		'projects',
		'icebergRepository'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlRepository class >> fromUrlString: aString [
	^ self new
		url: (ZnUrl fromString: aString)
]

{ #category : #comparing }
GtRlRepository >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self urlString asSymbol == anotherObject urlString asSymbol
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

{ #category : #ui }
GtRlRepository >> gtBranchesFor: aView [
	<gtView>
	^ aView list
		title: 'Branches' translated;
		items: [ self icebergRepository allBranches ];
		itemText: #gtSummaryDescription
]

{ #category : #ui }
GtRlRepository >> gtProjectsFor: aView [
	<gtView>
	^ aView list 
		title: 'Projects' translated;
		items: [ self projects ]
]

{ #category : #ui }
GtRlRepository >> gtRepoDependenciesFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Repo Dependencies';
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositories) asSet.
			mondrian nodes 
				shape: [ :aRepository | 
					| text element |
					text := [
						aRepository urlString asRopedText ]
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
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #ui }
GtRlRepository >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Repo Map';
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
					label := BlTextElement new
						text: aRepository urlString asRopedText;
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
		itemFormat: [ :anIceTag |
			anIceTag name, ' [', (anIceTag commit id first: 7), ']' ]
]

{ #category : #testing }
GtRlRepository >> hasVersion [
	^ self url segments first includes: $:
]

{ #category : #comparing }
GtRlRepository >> hash [ 
	^ self urlString hash
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

{ #category : #'accessing - dynamic' }
GtRlRepository >> id [ 	
	| urlCopy |
	urlCopy := self url copy.
	urlCopy segments: OrderedCollection new. 
	urlCopy addPathSegment: self projectName.
	(self url segments size > 1)
		ifTrue: [ urlCopy addPathSegments: (self url segments copyFrom: 2 to: self url segments size )  ].
	^ urlCopy asString.
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

{ #category : #testing }
GtRlRepository >> nameSegment [
	| size segmentIndex |
	size := self url segments size. 
	segmentIndex := size - 1. 
	segmentIndex == 0 ifTrue: [ segmentIndex := 1 ].
	^ self url segments at: segmentIndex.
	
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
		nextPutAll: self urlString;
		nextPutAll: ')'
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> projectName [
	| firstSegment |
	firstSegment := self url segments first.
	^ (firstSegment includes: $:)
		ifTrue: [ firstSegment copyUpTo: $: ]
		ifFalse: [ firstSegment ]
]

{ #category : #accessing }
GtRlRepository >> projects [ 
	^ projects
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> repositoryName [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyUpTo: $: ]
		ifFalse: [ nameSegment ]
]

{ #category : #accessing }
GtRlRepository >> url [
	^ url
]

{ #category : #accessing }
GtRlRepository >> url: aZnUrl [
	url := aZnUrl
]

{ #category : #accessing }
GtRlRepository >> urlString [
	^ self url asString
]

{ #category : #'accessing - dynamic' }
GtRlRepository >> urlWithVersion: aVersionString [
	| currentUrl |
	currentUrl := self url copy.
	currentUrl segments at: 1 put: self projectName,':', aVersionString. 
	^ currentUrl
]

{ #category : #accessing }
GtRlRepository >> versionString [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyAfter: $: ]
		ifFalse: [ Error signal: 'The repository does not have a version number.' ]
]
