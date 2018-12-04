Class {
	#name : #GtRlRelease,
	#superclass : #Object,
	#instVars : [
		'releaseActions'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlRelease >> addReleaseAction: aReleaseAction [
	^ self releaseActions addAction: aReleaseAction
]

{ #category : #ui }
GtRlRelease >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #accessing }
GtRlRelease >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := GtRlReleaseActionsGroup new ]
]
