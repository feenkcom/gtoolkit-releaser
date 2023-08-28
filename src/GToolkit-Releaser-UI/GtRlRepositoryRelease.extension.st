Extension { #name : #GtRlRepositoryRelease }

{ #category : #'*GToolkit-Releaser-UI' }
GtRlRepositoryRelease >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Release map' translated;
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositoryReleases) asSet.
			mondrian nodes 
				"umlClassShapeWithName: [ :aRepositoryRelease | aRepositoryRelease description ];"
				shape: [ :aRepositoryRelease | |container children label textColor |
					textColor := aRepositoryRelease isPassiveRelease 
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					label := BlTextElement new
						text: (aRepositoryRelease description asRopedText foreground: textColor);
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					children := BlElement new
						constraintsDo: [ :c | 
							c linear horizontal alignCenter ].
					children graph beChildrenContainer.
					container
						addChild: label;
						addChild: children.];
				with: repos;
				forEach: [ :aRepositoryRelease | 
					mondrian nodes
						shape: [ :aProjectRelease ||textColor text|
							textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
								ifTrue: [ Color gray ] ifFalse: [ Color black ].
							text := aProjectRelease project name asRopedText foreground: textColor.
							(BlTextElement text: text)
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c linear horizontal alignCenter ] ];
						with: aRepositoryRelease projectReleases.
						aRepositoryRelease isPassiveRelease ifFalse: [ 
							mondrian nodes
								shape: [ :aReleaseAction |
									|orderContainer|
									orderContainer := BlElement new
									layout: BlLinearLayout horizontal;
									zIndex: 1;
									constraintsDo: [ :c |
										c padding: (BlInsets all: 2).
										c horizontal fitContent.
										c vertical fitContent ].
									orderContainer graph beChildrenContainer.
									orderContainer ];
								with: {aRepositoryRelease};
								forEach: [ :aRepoRelease |
									| text |
									mondrian nodes 
										shape: [ :aReleaseAction | 
											text := aReleaseAction order printString asRopedText.
											(BlTextElement text: text)
												constraintsDo: [ :c | 
													c padding: (BlInsets all: 2)]];
										with: aRepoRelease allReleaseActions actions.
									mondrian layout custom: BlLinearLayout horizontal
									 ]].
					mondrian layout vertical].
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
					dependedRepos := each childRepositoryReleases.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradWestHierarchicalLayout new)]
]

{ #category : #'*GToolkit-Releaser-UI' }
GtRlRepositoryRelease >> gtRepositoryMapFor: aView [
	<gtView> 
	^ aView explicit
		title: 'Release graph';
		stencil: [
			| gtconnector options |
			gtconnector := GtConnector new.
			options := GtConnectorOptions new.
			options drawLines: false.
			gtconnector options: options.
			gtconnector stencil: [ :aRepositoryRelease | |container children label textColor |
					textColor := aRepositoryRelease isPassiveRelease 
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					container
						connector 
							model: aRepositoryRelease;
							beLayoutSource; 
							beLayoutTarget;
							beVisualTarget.
					label := BlTextElement new
						text: (aRepositoryRelease description asRopedText foreground: textColor);
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					children := BlElement new.
					children	layout: BlLinearLayout vertical.
					children						
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 2).
							c horizontal fitContent.
							c vertical fitContent.
							c linear horizontal alignCenter ].
					container
						addChild: label.
					aRepositoryRelease projectReleases do: [ :aProjectRelease |
						|text vocalProject|
						textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
								ifTrue: [ Color gray ] ifFalse: [ Color black ].
						text := aProjectRelease project name asRopedText foreground: textColor.
						
						vocalProject := BlElement new.
						vocalProject layout: BlLinearLayout vertical.
						vocalProject constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c horizontal fitContent.
									c vertical fitContent.
									c linear horizontal alignCenter].
						vocalProject addChild: ((BlTextElement text: text)" constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c horizontal fitContent.
									c vertical fitContent]").
						vocalProject connector beVisualSource.
						"aProjectRelease childReleases do: [ :each | 
							each repositoryRelease ~= aRepositoryRelease ifTrue: [
								vocalProject connector addToModelObjectList: each repositoryRelease]]."
						vocalProject when: BlDoubleClickEvent do: [ :event | 
							aProjectRelease childReleases do: [ :each | 
								each repositoryRelease ~= aRepositoryRelease ifTrue: [
									gtconnector addEntity: each repositoryRelease]]].
						children addChild: vocalProject].
				   container addChild: children.
					container].
			gtconnector addEntity: self.
			gtconnector asPannableElement ]
]
