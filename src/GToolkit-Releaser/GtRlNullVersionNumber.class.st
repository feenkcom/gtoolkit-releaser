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

{ #category : #testing }
GtRlNullVersionNumber >> < aMagnitude [ 
	"The null version number is typically used for the first version in a sequence.
	Answer true here and checks should be that the next version is > the first version."

	^ true
]

{ #category : #comparing }
GtRlNullVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ true
]

{ #category : #comparing }
GtRlNullVersionNumber >> hash [ 

	^ self class hash
]

{ #category : #testing }
GtRlNullVersionNumber >> isNullVersion [
	^ true
]

{ #category : #accessing }
GtRlNullVersionNumber >> versionString [
	^ 'unknown'
]
