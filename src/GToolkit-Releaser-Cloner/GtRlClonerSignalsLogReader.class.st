Class {
	#name : #GtRlClonerSignalsLogReader,
	#superclass : #GtRlSignalsLogReader,
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerSignalsLogReader class >> readFrom: aStream [
	^ self new
		readFrom: aStream
]

{ #category : #accessing }
GtRlClonerSignalsLogReader >> eventsGroupType [
	^ GtRlClonerSignalsGroup
]

{ #category : #initialization }
GtRlClonerSignalsLogReader >> initialize [ 
	super initialize.
	eventTypeIndicator := 'ClonerEvent'.
]
