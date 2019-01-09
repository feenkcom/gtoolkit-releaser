Class {
	#name : #GtRlExecuteActionSignal,
	#superclass : #GtRlActionSignal,
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #accessing }
GtRlExecuteActionSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: action order printString; 
		nextPutAll: ' Executed action: '; 
		nextPutAll: action description;
		nextPutAll: ' ';
		nextPutAll: action repositoryRelease repository repositoryName
]
