Class {
	#name : #FkRlTagVersion,
	#superclass : #FkRlVersion,
	#instVars : [
		'tagName'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlTagVersion >> tagName [
	^ tagName
]

{ #category : #accessing }
FkRlTagVersion >> tagName: aTagName [
	tagName := aTagName
]

{ #category : #accessing }
FkRlTagVersion >> versionString [
	^ self tagName
]
