Extension { #name : #IceCommit }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceCommit >> gtCommitAncestorsDominanceTreeFor: aView [
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

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceCommit >> gtCommitAncestorsTreeFor: aView [
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

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceCommit >> gtCommitsFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Ancestors' translated;
		items: [ self commits ];
		column: 'Timestamp' item: [ :aCommit | aCommit timeStamp asStringYMDHM ];
		column: 'Commit' item: #shortId;
		column: 'Author' item: #author;
		column: 'Description' item: #comment
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceCommit >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList 
		priority: 9;
		title: 'Details' translated;
		items: [ {
			'Commit'  -> ('[' , self commit shortId , '] ' , self commit id).
			'Parents' -> (self commit ancestors collect: #shortId) asCommaString.
			'Author'  -> self commit author.
			'Date'    -> self commit timeStamp asStringYMDHM.
			'Tags'    -> self tagNames asCommaString.
			'Comment' -> self commit comment } ];
		column: 'Property' item: #key;
		column: 'Value' item: #value
]
