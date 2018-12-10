Class {
	#name : #GtRlCommitIdVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'commitId'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlCommitIdVersionNumber >> commitId [ 
	^ commitId 
]

{ #category : #accessing }
GtRlCommitIdVersionNumber >> commitId: aCommitId [
	commitId := aCommitId 
]

{ #category : #accessing }
GtRlCommitIdVersionNumber >> description [ 
	^ self versionString first: 7
]

{ #category : #accessing }
GtRlCommitIdVersionNumber >> versionString [
	^ self commitId
]
