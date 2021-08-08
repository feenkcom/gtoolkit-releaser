"
I am null version number that can be used instead of `nil`.

{{gtExample:GtRlNullVersionNumberExamples>>#nullVersionNumber}}

A null version number is equal to any other null version number.
{{gtExample:GtRlNullVersionNumberExamples>>#nullVersionNumberEqualityExample}}


"
Class {
	#name : #GtRlNullVersionNumber,
	#superclass : #GtRlVersionNumber,
	#category : 'GToolkit-Releaser'
}

{ #category : #versions }
GtRlNullVersionNumber class >> versionString [
	^ 'unknown'
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
	^ self class versionString
]
