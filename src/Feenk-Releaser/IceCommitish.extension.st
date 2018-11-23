Extension { #name : #IceCommitish }

{ #category : #'*Feenk-Releaser' }
IceCommitish >> gtDetailsFor: aView [
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
