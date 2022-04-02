Class {
	#name : #GtRlClonerEventLogReader,
	#superclass : #Object,
	#instVars : [
		'events'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerEventLogReader class >> readFrom: aStream [
	^ self new
		readFrom: aStream
]

{ #category : #accessing }
GtRlClonerEventLogReader >> eventType [
	^ 'ClonerEvent'
]

{ #category : #initialization }
GtRlClonerEventLogReader >> readEventFromLine: aLine [
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
GtRlClonerEventLogReader >> readFrom: aStream [
	| newEvents typeIndicator |
	newEvents := GtRlClonerEventsGroup new.
	typeIndicator := '| ', self eventType ,' |'.
	aStream contents linesDo: [ :aLine |
		(aLine includesSubstring: typeIndicator) ifTrue: [
			| newEvent |
			newEvent := self readEventFromLine: aLine.
			newEvents add: newEvent ] ].
	^ newEvents
]
