Class {
	#name : #GtRlActionExecutionSignal,
	#superclass : #GtRlActionSignal,
	#instVars : [
		'actionType',
		'actionOrder',
		'actionDescription',
		'repositoryId',
		'versionDescription'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #accessing }
GtRlActionExecutionSignal >> actionDescription [
	^ actionDescription
]

{ #category : #accessing }
GtRlActionExecutionSignal >> actionOrder [
	^ actionOrder
]

{ #category : #accessing }
GtRlActionExecutionSignal >> actionProperties [ 
	^ { 
		'Action Type' -> self actionType.
		'Action Order' -> self actionOrder.
		'Action Description' -> self actionDescription.
		'Repository Id' -> self repositoryId.
		'Version Description' -> self versionDescription} asOrderedDictionary
]

{ #category : #accessing }
GtRlActionExecutionSignal >> actionType [
	^ actionType
]

{ #category : #accessing }
GtRlActionExecutionSignal >> asDictionary [
	^ super asDictionary, self actionProperties
]

{ #category : #initialization }
GtRlActionExecutionSignal >> initializeForAction: anAction [
	super initializeForAction: anAction.
	
	actionType := anAction className.
	actionOrder := anAction order.
	actionDescription := anAction description.
	repositoryId := action repositoryRelease repository id.
	versionDescription := anAction repositoryRelease version description.
]

{ #category : #initialization }
GtRlActionExecutionSignal >> initializeFromTimestamp: aTimestamp andData: dataParts [
	self basicTimestamp: aTimestamp.
	
	actionOrder := dataParts third.
	actionType := dataParts fourth.
	actionDescription := dataParts fifth.
	repositoryId := dataParts sixth.
	versionDescription := dataParts seventh.
	
	self basicProcessId: dataParts eighth
]

{ #category : #testing }
GtRlActionExecutionSignal >> isEndSignalType [
	^ false
]

{ #category : #testing }
GtRlActionExecutionSignal >> isStartSignalType [
	^ false
]

{ #category : #printing }
GtRlActionExecutionSignal >> printOneLineContentsOn: aStream [
	aStream 
		nextPut: $|; space.
	{ 
		'ReleaserSignal'.
		self actionOrder asString.
		self actionType.
		self actionDescription.
		self repositoryId.
		self versionDescription.
		self processId } 
			do: [ :each |
				aStream << each] 
			separatedBy: [
				aStream space; nextPut: $|; space ]
]

{ #category : #accessing }
GtRlActionExecutionSignal >> repositoryId [
	^ repositoryId
]

{ #category : #accessing }
GtRlActionExecutionSignal >> versionDescription [
	^ versionDescription
]
