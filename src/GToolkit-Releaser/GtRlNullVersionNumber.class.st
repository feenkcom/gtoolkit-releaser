Class {
	#name : #GtRlNullVersionNumber,
	#superclass : #GtRlVersionNumber,
	#category : #'GToolkit-Releaser'
}

{ #category : #comparing }
GtRlNullVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ true
]

{ #category : #testing }
GtRlNullVersionNumber >> isNullVersion [
	^ true
]

{ #category : #accessing }
GtRlNullVersionNumber >> versionString [
	^ 'unknown'
]
