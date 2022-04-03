Class {
	#name : #GtRlSignalsGroup,
	#superclass : #Object,
	#traits : 'TGtGroup',
	#classTraits : 'TGtGroup classTrait',
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlSignalsGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #adding }
GtRlSignalsGroup >> add: anEvent [ 
	^ self items add: anEvent
]

{ #category : #enumerating }
GtRlSignalsGroup >> detect: aBlock [
	^ self items detect: aBlock
]

{ #category : #ui }
GtRlSignalsGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ self items ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]

{ #category : #initialization }
GtRlSignalsGroup >> initialize [
	super initialize.
	items := OrderedCollection new.
]

{ #category : #initialization }
GtRlSignalsGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtRlSignalsGroup >> items [
	^ items
]
