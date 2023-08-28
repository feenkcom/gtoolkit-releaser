Extension { #name : #GtRlRepository }

{ #category : #'*GToolkit-Releaser-UI' }
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

{ #category : #'*GToolkit-Releaser-UI' }
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
