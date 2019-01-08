Class {
	#name : #GtRlCreateReleaseActionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'action'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlCreateReleaseActionSignal class >> action: anAction [
	^ self new 
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
	stream nextPutAll: action repositoryRelease nodeName; nextPutAll: ' action: '; nextPutAll: action name; nextPutAll: ' '; nextPutAll: action order printString 
]
