Class {
	#name : #FkRlCommitVersion,
	#superclass : #FkRlVersion,
	#instVars : [
		'commitId'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlCommitVersion >> commitId [ 
	^ commitId 
]

{ #category : #accessing }
FkRlCommitVersion >> commitId: aCommitId [
	commitId := aCommitId 
]

{ #category : #accessing }
FkRlCommitVersion >> description [ 
	^ self versionString first: 7
]

{ #category : #accessing }
FkRlCommitVersion >> versionString [
	^ self commitId
]
