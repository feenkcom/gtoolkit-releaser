Class {
	#name : #GtRlTagVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'tagName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #comparing }
GtRlTagVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self tagName = anObject tagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> tagName [
	^ tagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> tagName: aTagName [
	tagName := aTagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> versionString [
	^ self tagName
]
