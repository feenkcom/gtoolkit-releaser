"
I use as a version number a symbolic version having the format 'vx.y.z', where x,y,z are the major, minor and patch componets of the version numbers. 

For example, `v0.1.0` and 'v2.42.89' are version numbers that I can represent. 
I do not provide any default and I should be explicitly initialize before being used.
"
Class {
	#name : #GtRlSemanticVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'major',
		'minor',
		'patch'
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

{ #category : #comparison }
GtRlSemanticVersionNumber >> <= aFkRlSemanticVersion [ 
	self major > aFkRlSemanticVersion major ifTrue: [ ^ false ] .
	self minor > aFkRlSemanticVersion minor ifTrue: [ ^ false ] .
	self patch > aFkRlSemanticVersion patch ifTrue: [ ^ false ] .
	^ true.
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
GtRlSemanticVersionNumber >> versionString [
	^ 'v', self major printString, '.', self minor printString, '.', self patch printString 
]
