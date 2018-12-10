Class {
	#name : #GtRlTagVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'tagName'
	],
	#category : #'GToolkit-Releaser'
}

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
