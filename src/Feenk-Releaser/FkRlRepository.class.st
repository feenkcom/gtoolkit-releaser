Class {
	#name : #FkRlRepository,
	#superclass : #FkRlNode,
	#instVars : [
		'url',
		'projects',
		'icebergRepository'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
FkRlRepository class >> fromUrlString: aString [
	^ self new
		url: (ZnUrl fromString: aString)
]

{ #category : #'as yet unclassified' }
FkRlRepository class >> gtRepositories [
	| project builder repoToBaselinesMap allProjects |
	builder := FkRlModelBuilder new.
	repoToBaselinesMap := IdentityDictionary  new.
	project := builder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit/src'.
	allProjects := project withDeepCollect: #childProjects.
	(allProjects "select: #isGToolkitProject") do:[ :aProject |
		repoToBaselinesMap 
			at: aProject githubRepoURL asSymbol
			ifPresent: [ :aFkRlRepository | aFkRlRepository addProject: aProject ] 
			ifAbsentPut: [|repository| 
				repository := FkRlRepository fromUrlString: aProject githubRepoURL. 
				repository addProject: aProject. 
				repository ] ].
	^ repoToBaselinesMap.

]

{ #category : #comparing }
FkRlRepository >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self urlString asSymbol == anotherObject urlString asSymbol
]

{ #category : #accessing }
FkRlRepository >> addProject: aFkRlProject [
	projects add: aFkRlProject 
]

{ #category : #'accessing - dynamic' }
FkRlRepository >> childRepositories [ 
	^ (self projects flatCollect: [ :aProject | 
		aProject childProjects collect: #repository ]) asSet
			remove: self ifAbsent: [ ];
			yourself

]

{ #category : #ui }
FkRlRepository >> gtBranchesFor: aView [
	<gtView>
	^ aView list 
		title: 'Branches' translated;
		items: [ self icebergRepository allBranches ];
		itemFormat: #gtSummaryDescription
]

{ #category : #ui }
FkRlRepository >> gtProjectsFor: aView [
	<gtView>
	^ aView list 
		title: 'Projects' translated;
		items: [ self projects ]
]

{ #category : #ui }
FkRlRepository >> gtRepoDependenciesFor: aView [
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
FkRlRepository >> gtRepoMapFor: aView [
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
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #ui }
FkRlRepository >> gtTagsFor: aView [
	<gtView>
	^ aView list 
		title: 'Tags' translated;
		items: [ self icebergRepository tags ];
		itemFormat: [ :anIceTag |
			anIceTag name, ' [', (anIceTag commit id first: 7), ']' ]
]

{ #category : #testing }
FkRlRepository >> hasVersion [
	^ self url segments first includes: $:
]

{ #category : #comparing }
FkRlRepository >> hash [ 
	^ self urlString hash
]

{ #category : #'accessing - dynamic' }
FkRlRepository >> icebergRepository [
	"I act like a cache for the iceberg repository associated with this repository."
	^ icebergRepository ifNil: [
		icebergRepository := IceRepository registry detect: [ :anIceRepo | 
			anIceRepo name = self repositoryName ] ]
]

{ #category : #'accessing - dynamic' }
FkRlRepository >> id [ 	
	| urlCopy |
	urlCopy := self url copy.
	urlCopy segments: OrderedCollection new. 
	urlCopy addPathSegment: self projectName.
	(self url segments size > 1)
		ifTrue: [ urlCopy addPathSegments: (self url segments copyFrom: 2 to: self url segments size )  ].
	^ urlCopy asString.
]

{ #category : #initialization }
FkRlRepository >> initialize [ 
	super initialize.
	projects := OrderedCollection new.
]

{ #category : #'accessing - dynamic' }
FkRlRepository >> parentRepositories [ 
	^ (projects flatCollect: [ :aProject | 
		aProject parentProjects collect: #repository]) asSet
			remove: self ifAbsent: [ ];
			yourself
	
]

{ #category : #accessing }
FkRlRepository >> pathSegments [
	^ String streamContents: [:s | 
		self url segments asStringOn: s delimiter: '/']
]

{ #category : #printing }
FkRlRepository >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self urlString;
		nextPutAll: ')'
]

{ #category : #'accessing - dynamic' }
FkRlRepository >> projectName [
	| firstSegment |
	firstSegment := self url segments first.
	^ (firstSegment includes: $:)
		ifTrue: [ firstSegment copyUpTo: $: ]
		ifFalse: [ firstSegment ]
]

{ #category : #accessing }
FkRlRepository >> projects [ 
	^ projects
]

{ #category : #accessing }
FkRlRepository >> repositoryName [
	| firstPathSegment |
	firstPathSegment := self url segments first.
	^ (firstPathSegment includes: $:)
		ifTrue: [ firstPathSegment copyUpTo: $: ]
		ifFalse: [ firstPathSegment ]
]

{ #category : #accessing }
FkRlRepository >> url [
	^ url
]

{ #category : #accessing }
FkRlRepository >> url: aZnUrl [
	url := aZnUrl
]

{ #category : #accessing }
FkRlRepository >> urlString [
	^ self url asString
]
