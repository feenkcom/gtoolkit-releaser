Class {
	#name : #GtRlCreateReleaseActionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'release',
		'action'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlCreateReleaseActionSignal class >> release: aRelease action: anAction [
	^ self new 
	  release: aRelease;
	  action: anAction 
]

{ #category : #accessing }
GtRlCreateReleaseActionSignal >> action [
	^ action
]

{ #category : #accessing }
GtRlCreateReleaseActionSignal >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtRlCreateReleaseActionSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: release nodeName; nextPutAll: ' action: '; nextPutAll: action name; nextPutAll: ' '; nextPutAll: action order printString 
]

{ #category : #accessing }
GtRlCreateReleaseActionSignal >> release: anObject [
	release := anObject
]
