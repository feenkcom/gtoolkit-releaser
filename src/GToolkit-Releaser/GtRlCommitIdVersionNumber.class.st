"
I use the full id of a commit as a version number. I should only be used if a commit id is set.

{{gtExample:GtRlCommitIdVersionNumberExamples>>#commitIdVersionNumber}}

More examples are provided by the class {{gtClass:GtRlCommitIdVersionNumberExamples}}


"
Class {
	#name : 'GtRlCommitIdVersionNumber',
	#superclass : 'GtRlVersionNumber',
	#instVars : [
		'commitId'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : 'comparing' }
GtRlCommitIdVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self commitId = anObject commitId
]

{ #category : 'accessing' }
GtRlCommitIdVersionNumber >> commitId [ 
	^ commitId 
]

{ #category : 'accessing' }
GtRlCommitIdVersionNumber >> commitId: aCommitId [
	self assert: [ aCommitId notNil ] description: 'The commit id cannot be null'.
	self 
		assert: [ commitId isNil ]
		description: 'A version number that uses a commit id should be immutable'.
	commitId := aCommitId 
]

{ #category : 'accessing' }
GtRlCommitIdVersionNumber >> description [ 
	^ self versionString 
		ifNil: [ nil ] 
		ifNotNil: [ :aVersionString | aVersionString first: 7 ]
	
]

{ #category : 'comparing' }
GtRlCommitIdVersionNumber >> hash [
	^ (self species hash
		bitXor: self commitId hash)
]

{ #category : 'accessing' }
GtRlCommitIdVersionNumber >> versionString [
	^ self commitId
]
