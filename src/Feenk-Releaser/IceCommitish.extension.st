Extension { #name : #IceCommitish }

{ #category : #'*Feenk-Releaser' }
IceCommitish >> gtCommitAncestorsDominanceTreeFor: aView [
	<gtView>
	^ aView mondrian
		title: 'DominanceTree';
		priority: 60;
		painting: [ :view | 
			view nodes 
				stencil: [ :each |
					| element |
					element := BlElement new.
					element 	
						geometry: BlEllipse new;
						border: (BlBorder paint: Color black width: 1);
						size: 10@10;
						constraintsDo: [ :constraints | constraints padding: (BlInsets all: 5).
					each = self ifTrue: [element background: Color gray] ifFalse: [element background:  Color white]  ].
					element ];
				with: (self withDeepCollect: #ancestors) asSet.
			view edges connectToAll: #ancestors.
			view layout dominanceTree]
]

{ #category : #'*Feenk-Releaser' }
IceCommitish >> gtCommitAncestorsTreeFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree';
		priority: 50;
		painting: [ :view | 
			view nodes 
				stencil: [ :each |
					| element |
					element := BlElement new.
					element 	
						geometry: BlEllipse new;
						border: (BlBorder paint: Color black width: 1);
						size: 10@10;
						constraintsDo: [ :constraints | constraints padding: (BlInsets all: 5).
					each = self ifTrue: [element background: Color gray] ifFalse: [element background:  Color white]  ].
					element ];
				with: (self withDeepCollect: #ancestors) asSet.
			view edges connectToAll: #ancestors.
			view layout tree]
]
