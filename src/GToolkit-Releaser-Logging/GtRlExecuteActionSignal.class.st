Class {
	#name : #GtRlExecuteActionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'action'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #accessing }
GtRlExecuteActionSignal class >> action: anAction [
	^ self new
		action: anAction
]

{ #category : #accessing }
GtRlExecuteActionSignal >> action: anAction [
	action := anAction
]

{ #category : #accessing }
GtRlExecuteActionSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: action order printString; 
		nextPutAll: ' Executed action: '; 
		nextPutAll: action description;
		nextPutAll: ' ';
		nextPutAll: action repositoryRelease repository repositoryName
]
