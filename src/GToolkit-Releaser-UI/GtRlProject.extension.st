Extension { #name : #GtRlProject }

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProject >> gtProjectMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 1;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProject |
					BrLabel new text: aProject name; aptitude: BrGlamorousLabelAptitude ];
				with: self withAllChildProjects.
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
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]
