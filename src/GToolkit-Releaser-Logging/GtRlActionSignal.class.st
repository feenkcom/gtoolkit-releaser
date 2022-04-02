Class {
	#name : #GtRlActionSignal,
	#superclass : #GtReleaserSignal,
	#instVars : [
		'action'
	],
	#category : 'GToolkit-Releaser-Logging'
}

{ #category : #accessing }
GtRlActionSignal class >> action: anAction [
	^ self new
		action: anAction
]

{ #category : #accessing }
GtRlActionSignal >> action: anObject [
	action := anObject
]
