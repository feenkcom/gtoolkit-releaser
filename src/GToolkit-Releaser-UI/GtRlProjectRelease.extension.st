Extension { #name : #GtRlProjectRelease }

{ #category : #'*GToolkit-Releaser-UI' }
GtRlProjectRelease >> gtProjectMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 60;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProjectRelease ||textColor|
					textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					BlTextElement new 
						text: ((
							aProjectRelease project name, 
							', ', aProjectRelease repositoryRelease releaseDetailsDescription
						) asRopedText foreground: textColor) ];
				with: (self withDeepCollect: #childReleases).
			mondrian edges
				shape: [
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childReleases.
			mondrian layout custom: GtGradWestHierarchicalLayout new ]
]
