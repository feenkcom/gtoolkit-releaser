Extension { #name : #GtRlProjectLoadDirective }

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProjectLoadDirective >> gtFullLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Load map (full)' translated;
		priority: 10;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aLoadDirective |
					BrLabel new 
						text: aLoadDirective projectName; 
						aptitude: (BrGlamorousLabelAptitude new 
							in: [ :anAptitude |
								aLoadDirective = self ifTrue: [
									anAptitude bold ].
								anAptitude ]);
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: (self withAllChildActiveAndIgnoredLoadDirectived) removeDuplicates.
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color blue alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian edges
				passive;
				shape: [ 
					BlParabollaArcElement new 
						zIndex: -1;
						curvatureFraction: 0.3;
						border: (BlBorder paint: (Color lightGray alpha: 0.5) width: 1);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color lightGray alpha: 0.5); width: 1; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #ignoredChildLoadDirectives.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProjectLoadDirective >> gtLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Load map' translated;
		priority: 1;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aLoadDirective |
					BrLabel new 
						text: aLoadDirective projectName; 
						aptitude: BrGlamorousLabelAptitude;
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: self withAllChildLoadDirectived.
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color blue alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProjectLoadDirective >> gtParentLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Parents chain' translated;
		priority: 20;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aLoadDirective |
					BrLabel new 
						text: aLoadDirective projectName; 
						aptitude: BrGlamorousLabelAptitude;
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: (self withDeepCollect: #parentLoadDirectives).
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color blue alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProjectLoadDirective >> gtProjectWithDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 11;
		painting: [ :mondrian |
			| projectEdges |
			projectEdges := OrderedCollection new.
			self 
				withDeep: #childLoadDirectives 
				edgesDo: [ :from :to | projectEdges add: (from project -> to project) ].
			mondrian nodes 
				shape: [ :aProject |
					BrLabel new 
						text: aProject name; 
						aptitude: BrGlamorousLabelAptitude;
						in: [ :label | label userData at: #projectModel put: aProject ];
						yourself ];
				with: self project withAllChildProjects.
			mondrian edges
				shape: [ :each :fromElement :toElement |
					| isInLoadDirective |
					isInLoadDirective := (projectEdges anySatisfy: [:anEdge |
						(anEdge key = (fromElement userData at: #projectModel)) and: [
							anEdge value = (toElement userData at: #projectModel) ] ]).
					BlLineElement new 
						zIndex: -1;
						border: (isInLoadDirective 
							ifTrue: [(BlBorder  paint: (Color blue alpha: 0.5) width: 2)]
							ifFalse: [(BlBorder  paint: (Color gray alpha: 0.5) width: 1)]) ;
						toHead: (BlArrowheadSimpleArrow new
							border: (isInLoadDirective
								ifTrue: [ BlBorder builder paint: (Color blue alpha: 0.5); width: 2; build ]
								ifFalse: [ BlBorder builder paint: (Color gray alpha: 0.5); width: 1; build ])) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childProjects.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]
