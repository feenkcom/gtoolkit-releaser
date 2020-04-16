Class {
	#name : #GtRlBaselineVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'versionString'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #comparing }
GtRlBaselineVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self versionString = anObject versionString
]

{ #category : #accessing }
GtRlBaselineVersionNumber >> versionString [
	^ versionString
]

{ #category : #accessing }
GtRlBaselineVersionNumber >> versionString: aVersionString [
	self assert: [ aVersionString notNil ].
	self 
		assert: [ versionString isNil ]
		description: 'A version number that uses a baseline number should be immutable'.
	versionString := aVersionString
]
