Class {
	#name : #GtRlAddReleaseActionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'release',
		'action'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlAddReleaseActionSignal class >> release: aRelease action: anAction [
	^ self new 
	  release: aRelease;
	  action: anAction 
]

{ #category : #accessing }
GtRlAddReleaseActionSignal >> action [
	^ action
]

{ #category : #accessing }
GtRlAddReleaseActionSignal >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtRlAddReleaseActionSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: release nodeName; nextPutAll: ' action: '; nextPutAll: action name; nextPutAll: ' '; nextPutAll: action order printString 
]

{ #category : #accessing }
GtRlAddReleaseActionSignal >> release1 [
	^ release
]

{ #category : #accessing }
GtRlAddReleaseActionSignal >> release: anObject [
	release := anObject
]
