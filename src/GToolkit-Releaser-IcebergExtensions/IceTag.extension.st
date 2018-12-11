Extension { #name : #IceTag }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtAsSemanticVersionNumber [
	|tokens| 
	tokens := self name allButFirst findTokens: '.'. 
	^ GtRlSemanticVersionNumber 
		major: tokens first asInteger
		minor: tokens second asInteger
		patch: tokens third asInteger
]

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
		column: 'Timestamp' item: [ :aCommit | aCommit timeStamp asStringYMDHM ] width: 120;
		column: 'Commit' item: #shortId width: 70;
		column: 'Author' item: #author;
		column: 'Description' item: #comment
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtHeadCommitDetailsFor: aView [
	<gtView>
	^ self commit gtDetailsFor: aView
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtIsSemanticVersion [
	^ self name matchesRegex: 'v[0-9]+\.[0-9]+\.[0-9]+'
]
