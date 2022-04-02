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
				ifFalse: [ nil ] .
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

{ #category : #printing }
GtRlClonerBaselineEventsGroup >> description [
	^ String streamContents: [ :aStream |
		self descriptionOn: aStream ]
]

{ #category : #printing }
GtRlClonerBaselineEventsGroup >> descriptionOn: aStream [
	aStream
		nextPutAll: self baselineName; space;
		nextPut: $(;
		nextPutAll: self duration gtHumanReadableString;
		nextPut: $)
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> duration [
	^ self totalLoadDuration
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> events [
	^ events
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEventsGroup >> gtBarElements [
	^ (self gtBarElementsWithGlobalWeight: 1.0 local: 1.0) asScrollableElement
		margin: (BlInsets all: 10)
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEventsGroup >> gtBarElementsWithGlobalWeight: aWeight local: aLocalWeight [
	| taskElements aBarColor |
	
	aBarColor := BlColorTransition interpolate: Color veryLightGray to: BrGlamorousColors errorBorderColor at: aWeight.
	
	taskElements := aWeight > 0.1
		ifTrue: [
			| myDuration |		
			myDuration := self duration.
	
			self subgroups collect: [ :eachTask |
				| eachWeight |
				
				eachWeight := myDuration isZero
					ifTrue: [ 0 ]
					ifFalse: [ (eachTask duration / myDuration) asFloat ].
				(eachTask gtBarElementsWithGlobalWeight: eachWeight * aWeight local: eachWeight)
					constraintsDo: [ :c | c linear weight: (eachWeight max: 0.001) ] ] ]
		ifFalse: [
			self subgroups
				ifEmpty: [ #() ]
				ifNotEmpty: [ {
					BlElement new
						layout: BlLinearLayout horizontal;
						constraintsDo: [ :c |
							c horizontal matchParent.
							c vertical exact: 20 ];
						when: BlClickEvent
						do: [ :anEvent |
							anEvent consumed: true.
							anEvent currentTarget phlow spawnObject: self ];
						geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
						border: (BlBorder paint: Color transparent width: (aWeight max: 0.1));
						background: (BlLinearGradientPaint vertical stops: {
							0 -> aBarColor.
							0.4 -> (aBarColor alpha: 0.5).
							1 -> (aBarColor alpha: 0)}) } ] ].
	
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BlElement new
			layout: BlLinearLayout horizontal alignCenter;
			when: BlClickEvent
			do: [ :anEvent |
				anEvent consumed: true.
				anEvent currentTarget phlow spawnObject: self ];
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical exact: 20 ];
			padding: (BlInsets top: 3 bottom: 3);
			geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
			border: (BlBorder paint: Color transparent width: 0.25);
			background: aBarColor;
			in: [ :aPane | aWeight > 0.005
				ifTrue: [ aPane addChild: (BrLabel new
					aptitude: (BrGlamorousLabelAptitude new fontSize: 10);
					text: self description) asScalableElement ] ];
			yourself);
		addChild: (BlElement new
			layout: (BlLinearLayout horizontal alignTopCenter weightSum: 1);
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical fitContent ];
			addChildren: taskElements);
		yourself
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEventsGroup >> gtLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Clone map' translated;
		priority: 20;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aSubgroup |
					BrLabel new 
						text: aSubgroup description; 
						aptitude: BrGlamorousLabelAptitude;
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aSubgroup ] ];
				with: (self withDeepCollect: #subgroups).
			mondrian edges
				stencil: [:class | 
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.3;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #subgroups.
			mondrian layout  horizontalDominanceTree
				levelDistance: 100;
				nodeDistance: 10 ]
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEventsGroup >> gtMapFor: aView [
	<gtView>

	^ aView explicit
		title: 'Duration Map';
		priority: 20;
		stencil: [ self gtBarElements ]
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
	^ aView columnedTree
		title: 'Baselines (tree)';
		priority: 10;
		items: [ {self} ];
		children: #subgroups;
		column: 'Baseline' text: #baselineName;
		column: 'Total Duration' 
			text: [ :aGroup | aGroup totalLoadDuration ];
		column: 'Local Duration' 
			text: [ :aGroup | aGroup localLoadDuration ]
]

{ #category : #initialization }
GtRlClonerBaselineEventsGroup >> initialize [ 
	super initialize.
	events := GtRlClonerEventsGroup new. 
	subgroups := OrderedCollection new. 
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> loadCompletedEvent [
	^ self events detect: [ :anEvent |
		anEvent class = GtRlClonerBaselineLoadCompletedEvent ]
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> loadStartedEvent [
	^ self events detect: [ :anEvent |
		anEvent class = GtRlClonerBaselineLoadStartedEvent ]
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> localLoadDuration [
	^ self totalLoadDuration - (self subgroups sum: [ :aGroup | 
		aGroup totalLoadDuration ]) asDuration
]

{ #category : #printing }
GtRlClonerBaselineEventsGroup >> printOn: stream [
	super printOn: stream.
	stream 
		nextPutAll: '('.
	self descriptionOn: stream.
	stream
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> subgroups [
	^ subgroups
]

{ #category : #accessing }
GtRlClonerBaselineEventsGroup >> totalLoadDuration [
	^ self loadCompletedEvent timestamp - self loadStartedEvent timestamp
]
