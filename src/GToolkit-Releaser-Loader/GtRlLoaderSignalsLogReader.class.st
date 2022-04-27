Class {
	#name : #GtRlLoaderSignalsLogReader,
	#superclass : #GtRlSignalsLogReader,
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #initialization }
GtRlLoaderSignalsLogReader >> initialize [ 
	super initialize.
	eventTypeIndicator := 'LoaderEvent'.
]

{ #category : #accessing }
GtRlLoaderSignalsLogReader >> signalsGroupType [
	^ GtRlLoaderSignalsGroup
]
