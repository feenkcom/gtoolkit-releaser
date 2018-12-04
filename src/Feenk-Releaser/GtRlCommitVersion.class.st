Class {
	#name : #GtRlCommitVersion,
	#superclass : #GtRlVersion,
	#instVars : [
		'commitId'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlCommitVersion >> commitId [ 
	^ commitId 
]

{ #category : #accessing }
GtRlCommitVersion >> commitId: aCommitId [
	commitId := aCommitId 
]

{ #category : #accessing }
GtRlCommitVersion >> description [ 
	^ self versionString first: 7
]

{ #category : #accessing }
GtRlCommitVersion >> versionString [
	^ self commitId
]
