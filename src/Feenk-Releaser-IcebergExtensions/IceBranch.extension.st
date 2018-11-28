Extension { #name : #IceBranch }

{ #category : #'*Feenk-Releaser-IcebergExtensions' }
IceBranch >> gtCommitsFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Commits' translated;
		items: [ self commits ];
		column: 'Timestamp' item: [ :aCommit | aCommit timeStamp asStringYMDHM ];
		column: 'Commit' item: #shortId;
		column: 'Author' item: #author;
		column: 'Description' item: #comment
]

{ #category : #'*Feenk-Releaser-IcebergExtensions' }
IceBranch >> gtSummaryDescription [
	^ String streamContents: [ :aStream |
		aStream
			nextPutAll: self name;
			nextPutAll: ', ';
			nextPutAll: (self isLocal ifTrue: [ 'local' ] ifFalse: [ 'remote' ] ) ]
]
