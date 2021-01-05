Class {
	#name : #GtRlClonerBaselineEventsGroup,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'events',
		'subgroups'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #'instance creation' }
GtRlClonerBaselineEventsGroup class >> fromEvents: aCollection [
	| latestGroup groupsStack |
	
	groupsStack := Stack new.
	aCollection do: [ :anEvent | 
		anEvent class = GtRlClonerBaselineLoadStartedEvent ifTrue: [ 
			| newGroup topGroup |
			newGroup := self new
				baselineName: anEvent baselineName.
			topGroup := groupsStack size > 0 
				ifTrue: [ groupsStack top ]
				ifFalse: [ nil] .
			topGroup ifNotNil: [ 
				topGroup addSubgroup: newGroup ].
			newGroup addEvent: anEvent.
			groupsStack push: newGroup ].
		anEvent class = GtRlClonerBaselineLoadCompletedEvent ifTrue: [ 
			groupsStack top addEvent: anEvent.
			latestGroup := groupsStack pop ].
		
		((anEvent class ~= GtRlClonerBaselineLoadStartedEvent) and: [ 
			(anEvent class ~= GtRlClonerBaselineLoadCompletedEvent) ]) ifTrue: [ 
				groupsStack top addEvent: anEvent ] ].
		
	^ latestGroup
]

{ #category : #adding }
GtRlClonerBaselineEventsGroup >> addEvent: anEvent [
	self events add: anEvent
]

{ #category : #adding }
GtRlClonerBaselineEventsGroup >> addSubgroup: aGroup [
	self subgroups add: aGroup
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> events [
	^ events
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> gtViewEventsFor: aView [
	<gtView>
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ self events ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> gtViewSubgroupsFor: aView [
	<gtView>
	^ aView tree
		title: 'Baselines (tree)';
		items: [ {self} ];
		children: #subgroups;
		itemText: #baselineName
]

{ #category : #initialization }
GtRlClonerBaselineEventsGroup >> initialize [ 
	super initialize.
	events := OrderedCollection new. 
	subgroups := OrderedCollection new. 
]

{ #category : #printing }
GtRlClonerBaselineEventsGroup >> printOn: stream [
	super printOn: stream.
	stream 
		nextPutAll: '(';
		nextPutAll: self baselineName;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> subgroups [
	^ subgroups
]
