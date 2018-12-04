Class {
	#name : #GtRlTagVersion,
	#superclass : #GtRlVersion,
	#instVars : [
		'tagName'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlTagVersion >> tagName [
	^ tagName
]

{ #category : #accessing }
GtRlTagVersion >> tagName: aTagName [
	tagName := aTagName
]

{ #category : #accessing }
GtRlTagVersion >> versionString [
	^ self tagName
]
