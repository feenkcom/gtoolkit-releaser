"
I use as a version number a symbolic version having the format 'vx.y.z', where x,y,z are the major, minor and patch componets of the version numbers. 

For example, `v0.1.0` and 'v2.42.89' are version numbers that I can represent.
${example:GtRlSemanticVersionNumberExamples>>#semanticVersionNumber}$
 
I do not provide any default and I should be explicitly initialize before being used.
${example:GtRlSemanticVersionNumberExamples>>#uninitializedSemanticVersionNumber}$

More examples are provided by the class ${class:GtRlSemanticVersionNumberExamples}$
"
Class {
	#name : #GtRlSemanticVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'major',
		'minor',
		'patch',
		'iceTag'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlSemanticVersionNumber class >> major: majorNumber minor: minorNumber patch: patchNumber [
	^ self new 
		initializeMajor: majorNumber
		minor: minorNumber
		patch: patchNumber
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> < aSemanticVersionNumber [
	self major < aSemanticVersionNumber major ifTrue: [ ^ true ].
		self major = aSemanticVersionNumber major ifTrue: [ 
			self minor < aSemanticVersionNumber minor ifTrue: [ ^ true ].
			self minor = aSemanticVersionNumber minor ifTrue: [ 
				self patch < aSemanticVersionNumber patch ifTrue: [ ^ true ]]].
	^ false.
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> <= aSemanticVersionNumber [
	"Answer whether the receiver is less than or equal to the given version number."
	^ (self > aSemanticVersionNumber) not
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self major = anObject major and: [ 
		 self minor = anObject minor and: [ 
			self patch = anObject patch ] ]
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> > aSemanticVersionNumber [ 
	"Answer whether the receiver is greater than the argument."

	^aSemanticVersionNumber < self
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> >= aSemanticVersionNumber [ 
	"Answer whether the receiver is greater than or equal to the argument."

	^ aSemanticVersionNumber <= self
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> hash [
	^ ((self species hash
		bitXor: self major)
		bitXor: self minor)
		bitXor: self patch
]

{ #category : #initialization }
GtRlSemanticVersionNumber >> initializeMajor: aMajorNumber minor: aMinorNumber patch: aPatchNumber [
	self 
		assert: [ aMajorNumber notNil and: [ aMinorNumber notNil and: [ aPatchNumber notNil ] ] ]
		description: 'The components of a semantic version cannot be null'.
	self 
		assert: [ major isNil and: [ minor isNil and: [ patch isNil ] ] ]
		description: 'Semantic version numbers are immutable'.
	major := aMajorNumber.
	minor := aMinorNumber.
	patch := aPatchNumber.
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> major [
	^ major
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> minor [
	^ minor
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> patch [
	^ patch 
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> tag [
	^ iceTag
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> tag: anIceTag [
	iceTag := anIceTag 
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> versionString [
	^ 'v', self major printString, '.', self minor printString, '.', self patch printString 
]
