Class {
	#name : #GtRlNewCommits,
	#superclass : #Object,
	#instVars : [
		'repository',
		'newCommits'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlNewCommits >> addCommit: aCommit [
	newCommits add: aCommit.
]

{ #category : #accessing }
GtRlNewCommits >> initialize [
	newCommits := OrderedCollection new.
]

{ #category : #accessing }
GtRlNewCommits >> newCommits [
	^ newCommits
]

{ #category : #accessing }
GtRlNewCommits >> newCommits: anObject [
	newCommits := anObject
]

{ #category : #accessing }
GtRlNewCommits >> repository [
	^ repository
]

{ #category : #accessing }
GtRlNewCommits >> repository: anObject [
	repository := anObject
]
