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
	(allProjects select: #isGToolkitProject) do:[ :each |
		repoToBaselinesMap at: (each githubRepoURL asSymbol) 
			ifPresent: [ :aFkRlRepository | aFkRlRepository addProject: each ] 
			ifAbsentPut: [ |c| c := FkRlRepository new. c name: (each githubRepoURL asSymbol). c addProject: each. c ].
		].
	^ repoToBaselinesMap.

]

{ #category : #initialization }
FkRlRepository >> = anotherRepo [
	^ name = anotherRepo name
]

{ #category : #initialization }
FkRlRepository >> addProject: aFkRlProject [
	projects add: aFkRlProject 
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
			repos := self withDeepCollect: #parentRepositories.
			mondrian nodes 
				shape: [ :each | 
					| text element |
					text := [
						| displayString |
						displayString := (((each gtDisplayString 
							copyReplaceAll: 'BaselineOf' with: '')
							copyReplaceAll: 'ConfigurationOf' with: '')
							copyReplaceAll: 'GToolkit' with: 'GT ').
						displayString asRopedText ]
						on: Error do: [ :e | e asString asRopedText foreground: BrGlamorousColors linkWithErrorColor ].
					element := BlTextElement new.
					element 	
						text: text; 
						zIndex: 1.];
					with: repos.]
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
	urls collect: [ :url | self name asSymbol = url ifFalse: [ result add: (FkRlRepository gtRepositories at: url) ]].
	^ result
]

{ #category : #initialization }
FkRlRepository >> projects [ 
	^ projects
]
