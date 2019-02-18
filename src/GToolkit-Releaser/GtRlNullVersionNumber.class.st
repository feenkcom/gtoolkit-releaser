"
I am null version number that can be used instead of ==nil==.

${example:GtRlNullVersionNumberExamples>>#nullVersionNumber}$

A null version number is equal to any other null version number.
${example:GtRlNullVersionNumberExamples>>#nullVersionNumberEqualityExample}$
"
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
