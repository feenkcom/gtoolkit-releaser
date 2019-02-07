Class {
	#name : #GtRlMinimalRemote,
	#superclass : #Object,
	#instVars : [
		'name',
		'remoteRepository',
		'localRepository'
	],
	#category : #'GToolkit-Releaser-BaselineModel-MinimalIceberg'
}

{ #category : #accessing }
GtRlMinimalRemote >> localRepository: aRepository [
	
	localRepository := aRepository
]

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
