"
I use the full id of a commit as a version number. I should only be used if a commit already exists.
"
Class {
	#name : #GtRlCommitIdVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'commitId'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #comparing }
GtRlCommitIdVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self commitId = anObject commitId
]

{ #category : #accessing }
GtRlCommitIdVersionNumber >> commitId [ 
	^ commitId 
]

{ #category : #accessing }
GtRlCommitIdVersionNumber >> commitId: aCommitId [
	self assert: [ aCommitId notNil ] description: 'The commit id cannot be null'.
	self 
		assert: [ commitId isNil ]
		description: 'A version number that uses a commit id should be immutable'.
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
