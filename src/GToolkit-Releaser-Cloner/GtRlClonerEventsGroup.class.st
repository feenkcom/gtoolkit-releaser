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
