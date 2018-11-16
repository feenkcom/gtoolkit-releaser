Class {
	#name : #FkRlRepository,
	#superclass : #FkRlNode,
	#instVars : [
		'name',
		'projects'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'as yet unclassified' }
FkRlRepository class >> gtRepositories [
	| project builder repoToBaselinesMap allProjects |
	builder := FkRlModelBuilder new.
	repoToBaselinesMap := IdentityDictionary  new.
	project := builder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit/src'.
	allProjects := (project withDeepCollect: #childProjects).
	(allProjects "select: #isGToolkitProject") do:[ :each |
		repoToBaselinesMap at: (each githubRepoURL asSymbol) 
			ifPresent: [ :aFkRlRepository | aFkRlRepository addProject: each ] 
			ifAbsentPut: [ |c| c := FkRlRepository new. c name: (each githubRepoURL asSymbol). c addProject: each. c ].
		].
	^ repoToBaselinesMap.

]

{ #category : #initialization }
FkRlRepository >> = anotherRepo [
	anotherRepo ifNil: [ ^ false ].
	^ name asSymbol == anotherRepo name asSymbol
]

{ #category : #initialization }
FkRlRepository >> addProject: aFkRlProject [
	projects add: aFkRlProject 
]

{ #category : #initialization }
FkRlRepository >> childRepositories [ 
	| urls result |
	result := OrderedCollection new.
	urls := (projects flatCollect: [ :p | (p childProjects) collect: [ :parent |parent githubRepoURL asSymbol]]) asSet.
	urls collect: [ :url | self name asSymbol = url ifFalse: [ |toAdd| toAdd:=FkRlRepository gtRepositories at: url. toAdd ifNotNil: [result add: toAdd] ]].
	^ result
]

{ #category : #initialization }
FkRlRepository >> gtDisplayString [
	^ (name withoutPrefix: 'github://') withoutSuffix: '/src'
]

{ #category : #initialization }
FkRlRepository >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Repo Map';
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositories) asSet.
			mondrian nodes 
				shape: [ :each | 
					| text element |
					text := [
						each gtDisplayString asRopedText ]
						on: Error do: [ :e | e asString asRopedText foreground: BrGlamorousColors linkWithErrorColor ].
					element := BlTextElement new.
					element 	
						text: text; 
						zIndex: 1.];
					with: repos.
				mondrian edges
				shape: [ :each |
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.2;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build))  ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | |dependedRepos |
					dependedRepos := each childRepositories.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #initialization }
FkRlRepository >> hash [ 
	^ name hash
]

{ #category : #initialization }
FkRlRepository >> initialize [ 
	super initialize.
	projects := OrderedCollection new.
]

{ #category : #initialization }
FkRlRepository >> name [
	^ name
]

{ #category : #initialization }
FkRlRepository >> name: theRepoName [ 
	name := theRepoName 
]

{ #category : #initialization }
FkRlRepository >> parentRepositories [ 
	| urls result |
	result := OrderedCollection new.
	urls := (projects flatCollect: [ :p | (p parentProjects) collect: [ :parent |parent githubRepoURL asSymbol]]) asSet.
	urls collect: [ :url | self name asSymbol = url ifFalse: [ |toAdd| toAdd:=FkRlRepository gtRepositories at: url. toAdd ifNotNil: [result add: toAdd] ]].
	^ result
]

{ #category : #initialization }
FkRlRepository >> projects [ 
	^ projects
]
