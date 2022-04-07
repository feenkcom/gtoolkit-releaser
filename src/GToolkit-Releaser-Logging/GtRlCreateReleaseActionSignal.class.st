Class {
	#name : #GtRlCreateReleaseActionSignal,
	#superclass : #GtRlActionSignal,
	#category : 'GToolkit-Releaser-Logging'
}

{ #category : #accessing }
GtRlCreateReleaseActionSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: action repositoryRelease nodeName; nextPutAll: ' action: '; nextPutAll: action name; nextPutAll: ' '; nextPutAll: action order printString 
]
