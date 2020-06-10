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
GtRlSemanticVersionNumber class >> createFromString: aString [

	aString = 'unknown' ifTrue: [ ^ GtRlNullVersionNumber new ].
	^ (aString beginsWith: GtRlDevSemanticVersionNumber devVersionIdentifier) 
		ifTrue: [ GtRlDevSemanticVersionNumber readFromString: aString ]
		ifFalse: [ GtRlSemanticVersionNumber readFromString: aString ].
]

{ #category : #'instance creation' }
GtRlSemanticVersionNumber class >> major: majorNumber minor: minorNumber patch: patchNumber [
	^ self new 
		initializeMajor: majorNumber
		minor: minorNumber
		patch: patchNumber
]

{ #category : #converting }
GtRlSemanticVersionNumber class >> readFromString: aString [
	| tokens |
	tokens := aString allButFirst findTokens: '.'. 
	^ self 
		major: tokens first asInteger
		minor: tokens second asInteger
		patch: tokens third asInteger. 
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> < aSemanticVersionNumber [

	aSemanticVersionNumber isSemanticVersion ifFalse: [ ^ false ].
	self major < aSemanticVersionNumber major ifTrue: [ ^ true ].
		self major = aSemanticVersionNumber major ifTrue: [ 
			self minor < aSemanticVersionNumber minor ifTrue: [ ^ true ].
			self minor = aSemanticVersionNumber minor ifTrue: [ 
				self patch < aSemanticVersionNumber patch ifTrue: [ ^ true ]]].
	^ false.
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self major = anObject major and: [ 
		 self minor = anObject minor and: [ 
			self patch = anObject patch ] ]
]

{ #category : #converting }
GtRlSemanticVersionNumber >> asDevSemanticVersion [
	^ GtRlDevSemanticVersionNumber 
		major: self major 
		minor: self minor 
		patch: self patch
]

{ #category : #converting }
GtRlSemanticVersionNumber >> asDictionary [ 
]

{ #category : #comparing }
GtRlSemanticVersionNumber >> hash [
	^ ((self species hash
		bitXor: self major hash)
		bitXor: self minor hash)
		bitXor: self patch hash
]

{ #category : #initialization }
GtRlSemanticVersionNumber >> initializeMajor: aMajorNumber minor: aMinorNumber patch: aPatchNumber [
	self 
		assert: [ aMajorNumber notNil and: [ aMinorNumber notNil and: [ aPatchNumber notNil ] ] ]
		description: 'The components of a semantic version cannot be null'.
	self 
		assert: [ aMajorNumber >= 0 and: [ aMinorNumber >= 0 and: [ aPatchNumber >= 0 ] ] ]
		description: 'The components of a semantic version should not be negative'.
	self 
		assert: [ major isNil and: [ minor isNil and: [ patch isNil ] ] ]
		description: 'Semantic version numbers are immutable'.
	major := aMajorNumber.
	minor := aMinorNumber.
	patch := aPatchNumber.
]

{ #category : #testing }
GtRlSemanticVersionNumber >> isSemanticVersion [

	^ true
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
