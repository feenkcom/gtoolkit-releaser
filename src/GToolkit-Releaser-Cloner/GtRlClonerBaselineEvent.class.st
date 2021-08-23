Class {
	#name : 'GtRlClonerBaselineEvent',
	#superclass : 'BeaconSignal',
	#instVars : [
		'baselineName',
		'repositoryUrlString'
	],
	#category : 'GToolkit-Releaser-Cloner-Logging'
}

{ #category : 'converting' }
GtRlClonerBaselineEvent >> asDictionary [
	^ super asDictionary 
		at: #baselineName put: self baselineName;
		at: #repositoryUrlString put: self repositoryUrlString;
		yourself.
]

{ #category : 'accessing' }
GtRlClonerBaselineEvent >> baselineName [
	^ baselineName
]

{ #category : 'accessing' }
GtRlClonerBaselineEvent >> baselineName: anObject [
	baselineName := anObject
]

{ #category : 'accessing' }
GtRlClonerBaselineEvent >> eventName [
	^ 'Baseline Event'
]

{ #category : 'printing' }
GtRlClonerBaselineEvent >> printOneLineContentsOn: stream [
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

{ #category : 'accessing' }
GtRlClonerBaselineEvent >> repositoryUrlString [
	^ repositoryUrlString
]

{ #category : 'accessing' }
GtRlClonerBaselineEvent >> repositoryUrlString: anObject [
	repositoryUrlString := anObject
]
