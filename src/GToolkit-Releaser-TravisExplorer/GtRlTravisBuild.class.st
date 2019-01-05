Class {
	#name : #GtRlTravisBuild,
	#superclass : #Object,
	#instVars : [
		'travisProject',
		'buildData'
	],
	#category : #'GToolkit-Releaser-TravisExplorer'
}

{ #category : #accessing }
GtRlTravisBuild >> buildData [
	^ buildData
]

{ #category : #accessing }
GtRlTravisBuild >> buildData: aDictionary [
	buildData := aDictionary
]

{ #category : #accessing }
GtRlTravisBuild >> travisProject [
	^ travisProject
]

{ #category : #accessing }
GtRlTravisBuild >> travisProject: aProject [
	travisProject := aProject
]
