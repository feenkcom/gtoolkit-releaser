Class {
	#name : #GtRlSignalsLogReader,
	#superclass : #Object,
	#instVars : [
		'events',
		'eventTypeIndicator'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlSignalsLogReader class >> readFrom: aStream [
	^ self new
		readFrom: aStream
]

{ #category : #initialization }
GtRlSignalsLogReader >> readFrom: aStream [
	| newSignals typeIndicator |
	newSignals := self signalsGroupType new.
	typeIndicator := '| ', self signalTypeIndicator ,' |'.
	
	aStream contents linesDo: [ :aLine |
		(aLine includesSubstring: typeIndicator) ifTrue: [
			| newSignal |
			newSignal := self readSignalFromLine: aLine.
			newSignals add: newSignal ] ].
	
	^ newSignals
]

{ #category : #initialization }
GtRlSignalsLogReader >> readSignalFromLine: aLine [
	| timestampString signalClassName parts signalClass signal |
	
	parts := aLine splitOn: ' | '.
	
	timestampString := parts first copyUpTo: Character space.
	signalClassName := (parts first copyFrom: timestampString size + 1 to: parts first size) trimBoth.
	
	signalClass := signalClassName asClass.
	signal := signalClass new.
	signal 
		initializeFromTimestamp: timestampString asDateAndTime 
		andData: parts.
	^ signal
]

{ #category : #accessing }
GtRlSignalsLogReader >> signalTypeIndicator [
	^ eventTypeIndicator
]

{ #category : #accessing }
GtRlSignalsLogReader >> signalsGroupType [
	^ OrderedCollection
]
