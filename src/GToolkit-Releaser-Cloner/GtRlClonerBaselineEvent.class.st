Class {
	#name : #GtRlClonerBaselineEvent,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'signals',
		'subEvents'
	],
	#category : #'GToolkit-Releaser-Cloner-Logging'
}

{ #category : #'instance creation' }
GtRlClonerBaselineEvent class >> fromSignals: aCollectionOfSignals [
	| latestEvent eventsStack |
	
	eventsStack := Stack new.
	aCollectionOfSignals do: [ :aSignal | 
		aSignal class = GtRlClonerBaselineLoadStartedSignal ifTrue: [ 
			| newEvent topEvent |
			newEvent := self new
				baselineName: aSignal baselineName.
			topEvent := eventsStack size > 0 
				ifTrue: [ eventsStack top ]
				ifFalse: [ nil ] .
			topEvent ifNotNil: [ 
				topEvent addSubEvent: newEvent ].
			newEvent addSignal: aSignal.
			eventsStack push: newEvent ].
		aSignal class = GtRlClonerBaselineLoadCompletedSignal ifTrue: [ 
			eventsStack top addSignal: aSignal.
			latestEvent := eventsStack pop ].
		
		((aSignal class ~= GtRlClonerBaselineLoadStartedSignal) and: [ 
			(aSignal class ~= GtRlClonerBaselineLoadCompletedSignal) ]) ifTrue: [ 
				eventsStack top addSignal: aSignal ] ].
		
	^ latestEvent
]

{ #category : #adding }
GtRlClonerBaselineEvent >> addSignal: aSignal [
	self signals add: aSignal
]

{ #category : #adding }
GtRlClonerBaselineEvent >> addSubEvent: anEvent [
	self subEvents add: anEvent
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #printing }
GtRlClonerBaselineEvent >> description [
	^ String streamContents: [ :aStream |
		self descriptionOn: aStream ]
]

{ #category : #printing }
GtRlClonerBaselineEvent >> descriptionOn: aStream [
	aStream
		nextPutAll: self baselineName; space;
		nextPut: $(;
		print: self duration;
		nextPut: $)
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> duration [
	^ self totalLoadDuration
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtBarElements [
	^ (self gtBarElementsWithGlobalWeight: 1.0 local: 1.0) asScrollableElement
		margin: (BlInsets all: 10)
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtBarElementsWithGlobalWeight: aWeight local: aLocalWeight [
	| taskElements aBarColor |
	
	aBarColor := BlColorTransition interpolate: Color veryLightGray to: BrGlamorousColors errorBorderColor at: aWeight.
	
	taskElements := aWeight > 0.1
		ifTrue: [
			| myDuration |		
			myDuration := self duration.
	
			self subEvents collect: [ :anEvent |
				| eachWeight |
				
				eachWeight := myDuration isZero
					ifTrue: [ 0 ]
					ifFalse: [ (anEvent duration / myDuration) asFloat ].
				(anEvent gtBarElementsWithGlobalWeight: eachWeight * aWeight local: eachWeight)
					constraintsDo: [ :c | c linear weight: (eachWeight max: 0.001) ] ] ]
		ifFalse: [
			self subEvents
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
GtRlClonerBaselineEvent >> gtLoadDirectivesMapFor: aView [
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
				with: (self withDeepCollect: #subEvents).
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
				connectToAll: #subEvents.
			mondrian layout  horizontalDominanceTree
				levelDistance: 100;
				nodeDistance: 10 ]
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtMapFor: aView [
	<gtView>

	^ aView explicit
		title: 'Duration Map';
		priority: 20;
		stencil: [ self gtBarElements ]
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtViewAllSignalsFor: aView [
	<gtView>
	^ aView forward
	 	title: 'Signals (all)';
	 	priority: 33;
	 	object: [ GtRlClonerSignalsGroup 
			withAll: (self withDeep: #subEvents flatCollect: #signals) ];
	 	view: #gtItemsFor:
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtViewLocalSignalsFor: aView [
	<gtView>
	^ aView forward
	 	title: 'Signals (local)';
	 	priority: 30;
	 	object: [ self signals ];
	 	view: #gtItemsFor:
]

{ #category : #'gt-extensions' }
GtRlClonerBaselineEvent >> gtViewSubEventsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Baselines (tree)';
		priority: 10;
		items: [ {self} ];
		children: #subEvents;
		column: 'Baseline' text: #baselineName;
		column: 'Total Duration' 
			text: [ :aGroup | aGroup totalLoadDuration ];
		column: 'Local Duration' 
			text: [ :aGroup | aGroup localLoadDuration ]
]

{ #category : #initialization }
GtRlClonerBaselineEvent >> initialize [ 
	super initialize.
	signals := GtRlClonerSignalsGroup new. 
	subEvents := OrderedCollection new. 
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> loadCompletedEvent [
	^ self signals detect: [ :aSignal |
		aSignal class = GtRlClonerBaselineLoadCompletedSignal ]
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> loadStartedEvent [
	^ self signals detect: [ :aSignal |
		aSignal class = GtRlClonerBaselineLoadStartedSignal ]
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> localLoadDuration [
	^ self totalLoadDuration - (self subEvents sum: [ :aGroup | 
		aGroup totalLoadDuration ]) asDuration
]

{ #category : #printing }
GtRlClonerBaselineEvent >> printOn: stream [
	super printOn: stream.
	stream 
		nextPutAll: '('.
	self descriptionOn: stream.
	stream
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> signals [
	^ signals
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> subEvents [
	^ subEvents
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> totalLoadDuration [
	^ self loadCompletedEvent timestamp - self loadStartedEvent timestamp
]
