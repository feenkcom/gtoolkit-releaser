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
GtRlBaselineVersionNumber >> versionString: anObject [
	versionString := anObject
]
