Extension { #name : #IceTag }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtCommitAncestorsFor: aView [
	<gtView>
	^ (self commit
		gtCommitAncestorsDominanceTreeFor: aView)
			title: 'Commits tree'
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtCommitsFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Commits' translated;
		items: [ self commits ];
		column: 'Timestamp' item: [ :aCommit | aCommit timeStamp asStringYMDHM ];
		column: 'Commit' item: #shortId;
		column: 'Author' item: #author;
		column: 'Description' item: #comment
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtHeadCommitDetailsFor: aView [
	<gtView>
	^ self commit gtDetailsFor: aView
]
