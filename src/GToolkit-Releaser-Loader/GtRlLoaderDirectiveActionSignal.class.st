Class {
	#name : #GtRlLoaderDirectiveActionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'baselineName',
		'actionType',
		'actionDescription',
		'repositoryUrlString'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> actionDescription [

	^ actionDescription
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> actionDescription: anObject [

	actionDescription := anObject
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> actionType [

	^ actionType
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> actionType: anObject [

	actionType := anObject
]

{ #category : #converting }
GtRlLoaderDirectiveActionSignal >> asDictionary [
	^ super asDictionary 
		at: #baselineName put: self baselineName;
		at: #repositoryUrlString put: self repositoryUrlString;
		yourself.
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> baselineName [

	^ baselineName
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> baselineName: anObject [

	baselineName := anObject
]

{ #category : #printing }
GtRlLoaderDirectiveActionSignal >> printOneLineContentsOn: stream [
	stream 
		nextPut: $|; space;
		nextPutAll: 'LoaderEvent';
		space; nextPut: $|; space;
		nextPutAll: self baselineName;
		space; nextPut: $|; space;
		nextPutAll: self actionType;
		space; nextPut: $|; space;
		nextPutAll: self actionDescription;
		space; nextPut: $|; space;
		nextPutAll: self repositoryUrlString;
		space; nextPut: $|; space;
		nextPutAll: self processId
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> repositoryUrlString [

	^ repositoryUrlString
]

{ #category : #accessing }
GtRlLoaderDirectiveActionSignal >> repositoryUrlString: anObject [

	repositoryUrlString := anObject
]
