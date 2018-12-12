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
		major: majorNumber; 
		minor: minorNumber; 
		patch: patchNumber
]

{ #category : #comparison }
GtRlSemanticVersionNumber >> <= aFkRlSemanticVersion [ 
	self major > aFkRlSemanticVersion major ifTrue: [ ^ false ] .
	self minor > aFkRlSemanticVersion minor ifTrue: [ ^ false ] .
	self patch > aFkRlSemanticVersion patch ifTrue: [ ^ false ] .
	^ true.
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> initialize [ 
	major := 0. 
	minor := 0. 
	patch := 0
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> major [
	^ major
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> major: anInteger [
	major := anInteger
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> minor [
	^ minor
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> minor: anInteger [
	minor := anInteger
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> patch [
	^ patch
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> patch: anInteger [
	patch := anInteger
]

{ #category : #accessing }
GtRlSemanticVersionNumber >> versionString [
	^ 'v', major printString, '.', minor printString, '.', patch printString 
]
