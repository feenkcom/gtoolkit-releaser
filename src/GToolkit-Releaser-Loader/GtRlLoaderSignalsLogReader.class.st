Class {
	#name : #GtRlLoaderSignalsLogReader,
	#superclass : #GtRlSignalsLogReader,
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlLoaderSignalsLogReader >> eventsGroupType [
	^ GtRlLoaderSignalsGroup
]

{ #category : #initialization }
GtRlLoaderSignalsLogReader >> initialize [ 
	super initialize.
	eventTypeIndicator := 'LoaderEvent'.
]
