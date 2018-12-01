Class {
	#name : #FkRlRelease,
	#superclass : #Object,
	#instVars : [
		'releaseActions'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlRelease >> addReleaseAction: aReleaseAction [
	^ self releaseActions add: aReleaseAction
]

{ #category : #accessing }
FkRlRelease >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := OrderedCollection new ]
]
