Class {
	#name : #GtRlMinimalRemote,
	#superclass : #Object,
	#instVars : [
		'name',
		'remoteRepository'
	],
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #accessing }
GtRlMinimalRemote >> name [
	^ name
]

{ #category : #accessing }
GtRlMinimalRemote >> name: aString [ 
	name := aString
]

{ #category : #accessing }
GtRlMinimalRemote >> remoteRepository [
	^ remoteRepository
]

{ #category : #accessing }
GtRlMinimalRemote >> remoteRepository: aRepository [ 
	remoteRepository := aRepository
]
