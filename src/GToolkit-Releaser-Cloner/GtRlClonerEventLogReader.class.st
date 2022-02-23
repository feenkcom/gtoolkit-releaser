Class {
	#name : #GtRlClonerEventLogReader,
	#superclass : #Object,
	#instVars : [
		'events'
	],
	#category : 'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerEventLogReader class >> readFrom: aStream [
	^ self new
		readFrom: aStream
]

{ #category : #initialization }
GtRlClonerEventLogReader >> readEventFromLine: aLine [
	| timestampString eventClassName parts eventClass event |
	
	parts := aLine splitOn: ' | '.
	
	timestampString := parts first copyUpTo: Character space.
	eventClassName := (parts first copyFrom: timestampString size +1  to: parts first size) trimBoth.
	
	eventClass := eventClassName asClass.
	event := eventClass new.
	event 	
		basicTimestamp: timestampString asDateAndTime;
		baselineName: parts third;
		repositoryUrlString: parts fourth;
		basicProcessId: parts fifth .
	^ event
]

{ #category : #initialization }
GtRlClonerEventLogReader >> readFrom: aStream [
	| newEvents |
	newEvents := GtRlClonerEventsGroup new.
	aStream contents linesDo: [ :aLine |
		(aLine includesSubstring: '| ClonerEvent |') ifTrue: [
			| newEvent |
			newEvent := self readEventFromLine: aLine.
			newEvents add: newEvent ] ].
	^ newEvents
]
