Class {
	#name : #GtRlClonerEventsGroup,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerEventsGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #adding }
GtRlClonerEventsGroup >> add: anEvent [ 
	^ self items add: anEvent
]

{ #category : #enumerating }
GtRlClonerEventsGroup >> do: aBlock [
	^ self items do: aBlock
]

{ #category : #ui }
GtRlClonerEventsGroup >> gtItemsFor: aView [
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
GtRlClonerEventsGroup >> initialize [
	super initialize.
	items := OrderedCollection new.
]

{ #category : #initialization }
GtRlClonerEventsGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtRlClonerEventsGroup >> items [
	^ items
]
