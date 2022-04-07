Class {
	#name : #GtRlClonerBaselineSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'baselineName',
		'repositoryUrlString'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #converting }
GtRlClonerBaselineSignal >> asDictionary [
	^ super asDictionary 
		at: #baselineName put: self baselineName;
		at: #repositoryUrlString put: self repositoryUrlString;
		yourself.
]

{ #category : #accessing }
GtRlClonerBaselineSignal >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineSignal >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #accessing }
GtRlClonerBaselineSignal >> eventName [
	^ 'Cloner Event'
]

{ #category : #initialization }
GtRlClonerBaselineSignal >> initializeFromTimestamp: aTimestamp andData: dataParts [
	self 	
		basicTimestamp: aTimestamp;
		baselineName: dataParts third;
		repositoryUrlString: dataParts fourth;
		basicProcessId: dataParts fifth
]

{ #category : #printing }
GtRlClonerBaselineSignal >> printOneLineContentsOn: stream [
	stream 
		nextPut: $|; space;
		nextPutAll: 'ClonerEvent';
		space; nextPut: $|; space;
		nextPutAll: self baselineName;
		space; nextPut: $|; space;
		nextPutAll: self repositoryUrlString;
		space; nextPut: $|; space;
		nextPutAll: self processId
]

{ #category : #accessing }
GtRlClonerBaselineSignal >> repositoryUrlString [
	^ repositoryUrlString
]

{ #category : #accessing }
GtRlClonerBaselineSignal >> repositoryUrlString: anObject [
	repositoryUrlString := anObject
]
