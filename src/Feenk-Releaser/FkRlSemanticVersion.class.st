Class {
	#name : #FkRlSemanticVersion,
	#superclass : #Object,
	#instVars : [
		'major',
		'minor',
		'patch'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #comparison }
FkRlSemanticVersion >> <= aFkRlSemanticVersion [ 
	self major > aFkRlSemanticVersion major ifTrue: [ ^ false ] .
	self minor > aFkRlSemanticVersion minor ifTrue: [ ^ false ] .
	self patch > aFkRlSemanticVersion patch ifTrue: [ ^ false ] .
	^ true.
]

{ #category : #accessing }
FkRlSemanticVersion >> incrementPatch [
	patch := patch + 1
]

{ #category : #accessing }
FkRlSemanticVersion >> initialize [ 
	major := 0. minor := 0. patch := 0
]

{ #category : #accessing }
FkRlSemanticVersion >> major [
	^ major
]

{ #category : #accessing }
FkRlSemanticVersion >> major: anInteger [
	major := anInteger
]

{ #category : #accessing }
FkRlSemanticVersion >> minor [
	^ minor
]

{ #category : #accessing }
FkRlSemanticVersion >> minor: anInteger [
	minor := anInteger
]

{ #category : #accessing }
FkRlSemanticVersion >> patch [
	^ patch
]

{ #category : #accessing }
FkRlSemanticVersion >> patch: anInteger [
	patch := anInteger
]

{ #category : #accessing }
FkRlSemanticVersion >> printString [
	^ major printString, '.', minor printString, '.', patch printString 
]
