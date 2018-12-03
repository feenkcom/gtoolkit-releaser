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
	^ self releaseActions addAction: aReleaseAction
]

{ #category : #ui }
FkRlRelease >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #accessing }
FkRlRelease >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := FkRlReleaseActionsGroup new ]
]
