Class {
	#name : #GtRlSemanticVersion,
	#superclass : #GtRlVersion,
	#instVars : [
		'major',
		'minor',
		'patch'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
GtRlSemanticVersion class >> major: majorNumber minor: minorNumber patch: patchNumber [
	^ self new 
		major: majorNumber; 
		minor: minorNumber; 
		patch: patchNumber
]

{ #category : #comparison }
GtRlSemanticVersion >> <= aFkRlSemanticVersion [ 
	self major > aFkRlSemanticVersion major ifTrue: [ ^ false ] .
	self minor > aFkRlSemanticVersion minor ifTrue: [ ^ false ] .
	self patch > aFkRlSemanticVersion patch ifTrue: [ ^ false ] .
	^ true.
]

{ #category : #accessing }
GtRlSemanticVersion >> initialize [ 
	major := 0. 
	minor := 0. 
	patch := 0
]

{ #category : #accessing }
GtRlSemanticVersion >> major [
	^ major
]

{ #category : #accessing }
GtRlSemanticVersion >> major: anInteger [
	major := anInteger
]

{ #category : #accessing }
GtRlSemanticVersion >> minor [
	^ minor
]

{ #category : #accessing }
GtRlSemanticVersion >> minor: anInteger [
	minor := anInteger
]

{ #category : #accessing }
GtRlSemanticVersion >> patch [
	^ patch
]

{ #category : #accessing }
GtRlSemanticVersion >> patch: anInteger [
	patch := anInteger
]

{ #category : #accessing }
GtRlSemanticVersion >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self versionString;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlSemanticVersion >> versionString [
	^ major printString, '.', minor printString, '.', patch printString 
]
