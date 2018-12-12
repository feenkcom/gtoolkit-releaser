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
GtRlRelease >> decorateText: aStringOrText [
	^ self isPassiveRelease
		ifTrue: [ aStringOrText asRopedText foreground: Color gray ] 
		ifFalse: [ aStringOrText asRopedText]
]

{ #category : #ui }
GtRlRelease >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #testing }
GtRlRelease >> isPassiveRelease [
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
