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
	(GtRlCreateReleaseActionSignal release: self action: aReleaseAction) emit.
	^ self releaseActions addAction: aReleaseAction
]

{ #category : #ui }
GtRlRelease >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #testing }
GtRlRelease >> hasReleaseActions [ 
	^ self releaseActions isEmpty not
]

{ #category : #accessing }
GtRlRelease >> nodeName [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlRelease >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := GtRlReleaseActionsGroup new ]
]

{ #category : #actions }
GtRlRelease >> resetReleaseActions [
	self releaseActions removeAll.
]
