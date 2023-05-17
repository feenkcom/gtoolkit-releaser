Class {
	#name : #GtRlIceCommitsGroup,
	#superclass : #Object,
	#instVars : [
		'commits'
	],
	#category : 'GToolkit-Releaser-IcebergExtensions'
}

{ #category : #'instance creation' }
GtRlIceCommitsGroup class >> forCommits: aCollectionOfCommits [
	^ self new
		commits: aCollectionOfCommits
]

{ #category : #accessing }
GtRlIceCommitsGroup >> commits [
	^ commits
]

{ #category : #accessing }
GtRlIceCommitsGroup >> commits: aCollectionOfCommits [
	commits := aCollectionOfCommits
]

{ #category : #ui }
GtRlIceCommitsGroup >> gtViewCommitsListFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Commits' translated;
		items: [ self commits ];
		column: 'Timestamp' text: [ :aCommit | aCommit timeStamp asStringYMDHM ] width: 120;
		column: 'Author' text: #author width: 80;
		column: 'Description' text: #comment;
		column: 'Commit' text: #shortId width: 70
]
