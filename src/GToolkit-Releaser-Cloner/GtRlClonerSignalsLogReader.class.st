Class {
	#name : #GtRlClonerSignalsLogReader,
	#superclass : #GtRlSignalsLogReader,
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #initialization }
GtRlClonerSignalsLogReader >> initialize [ 
	super initialize.
	eventTypeIndicator := 'ClonerEvent'.
]

{ #category : #accessing }
GtRlClonerSignalsLogReader >> signalsGroupType [
	^ GtRlClonerSignalsGroup
]
