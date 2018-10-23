Class {
	#name : #FkRlPackage,
	#superclass : #FkRlNode,
	#instVars : [
		'project'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlPackage >> project [
	^ project
]

{ #category : #accessing }
FkRlPackage >> project: aProject [
	project := aProject
]
