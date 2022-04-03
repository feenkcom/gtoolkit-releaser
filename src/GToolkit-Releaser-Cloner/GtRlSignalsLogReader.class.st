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

{ #category : #accessing }
GtRlSignalsLogReader >> eventTypeIndicator [
	^ eventTypeIndicator
]

{ #category : #accessing }
GtRlSignalsLogReader >> eventsGroupType [
	^ OrderedCollection
]

{ #category : #initialization }
GtRlSignalsLogReader >> readEventFromLine: aLine [
	| timestampString eventClassName parts eventClass event |
	
	parts := aLine splitOn: ' | '.
	
	timestampString := parts first copyUpTo: Character space.
	eventClassName := (parts first copyFrom: timestampString size + 1 to: parts first size) trimBoth.
	
	eventClass := eventClassName asClass.
	event := eventClass new.
	event 
		initializeFromTimestamp: timestampString asDateAndTime 
		andData: parts.
	^ event
]

{ #category : #initialization }
GtRlSignalsLogReader >> readFrom: aStream [
	| newEvents typeIndicator |
	newEvents := self eventsGroupType new.
	typeIndicator := '| ', self eventTypeIndicator ,' |'.
	aStream contents linesDo: [ :aLine |
		(aLine includesSubstring: typeIndicator) ifTrue: [
			| newEvent |
			newEvent := self readEventFromLine: aLine.
			newEvents add: newEvent ] ].
	^ newEvents
]
