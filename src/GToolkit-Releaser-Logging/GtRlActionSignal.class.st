Class {
	#name : #GtRlActionSignal,
	#superclass : #GtRlReleaserSignal,
	#instVars : [
		'action'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'instance creation' }
GtRlActionSignal class >> forAction: anAction [
	^ self new
		initializeForAction: anAction
]

{ #category : #accessing }
GtRlActionSignal >> action: anObject [
	action := anObject
]

{ #category : #initialization }
GtRlActionSignal >> initializeForAction: anAction [
	self action:  anAction
]
