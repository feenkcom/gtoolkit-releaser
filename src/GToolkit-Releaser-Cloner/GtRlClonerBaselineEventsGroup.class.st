Class {
	#name : #GtRlClonerBaselineEventsGroup,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'events',
		'subgroups'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
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
GtRlClonerBaselineEventsGroup >> gtViewAllEventsFor: aView [
	<gtView>
	^ aView forward
	 	title: 'Events (all)';
	 	priority: 33;
	 	object: [ GtRlClonerEventsGroup 
			withAll: (self withDeep: #subgroups flatCollect: #events) ];
	 	view: #gtItemsFor:
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> gtViewLocalEventsFor: aView [
	<gtView>
	^ aView forward
	 	title: 'Events (local)';
	 	priority: 30;
	 	object: [ self events ];
	 	view: #gtItemsFor:
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
	events := GtRlClonerEventsGroup new. 
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
