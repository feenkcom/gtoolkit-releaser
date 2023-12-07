Class {
	#name : #GtRlLoadedConsolidatedBaselineEvent,
	#superclass : #Object,
	#instVars : [
		'clonerEvent',
		'loaderEvents',
		'subEvents'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent class >> fromContents: aLog [
	| baselineCloneEvent actionEvents consolidatedEvent |
	baselineCloneEvent := GtRlClonerBaselineEvent fromContents: aLog. 
	actionEvents := GtRlLoaderEventsGroup fromContents:  aLog.
	
	consolidatedEvent := self new
		initializeFrom: baselineCloneEvent.
	consolidatedEvent addLoaderEvents: actionEvents.
	
	^ consolidatedEvent
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent class >> readFromFile: aFileReference [
	^ aFileReference readStreamDo: [ :aStream | 
		self fromContents: aStream contents ]
]

{ #category : #initialization }
GtRlLoadedConsolidatedBaselineEvent >> addLoaderEvents: aGroup [ 
	| byBaselineGroups |
	byBaselineGroups := aGroup groupedByBaseline.
	self withDeep: #subEvents do: [ :anEvent |
		byBaselineGroups 
			at: anEvent baselineName 
			ifPresent: [ :baselineEvents |
				anEvent loaderEvents: baselineEvents ] ]
]

{ #category : #adding }
GtRlLoadedConsolidatedBaselineEvent >> addSubEvent: anEvent [
	self subEvents add: anEvent
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> baselineName [
	^ self clonerEvent baselineName 
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> clonerEvent [
	^ clonerEvent
]

{ #category : #printing }
GtRlLoadedConsolidatedBaselineEvent >> description [
	^ String streamContents: [ :aStream |
		self descriptionOn: aStream ]
]

{ #category : #printing }
GtRlLoadedConsolidatedBaselineEvent >> descriptionOn: aStream [
	aStream
		nextPutAll: self baselineName; space;
		nextPut: $(;
		nextPutAll: self totalDuration gtHumanReadableString;
		nextPut: $)
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtBarElements [
	^ (self gtBarElementsWithGlobalWeight: 1.0 local: 1.0) asScrollableElement
		margin: (BlInsets all: 10)
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtBarElementsWithGlobalWeight: aWeight local: aLocalWeight [
	| taskElements aBarColor |
	
	aBarColor := BlColorTransition interpolate: Color veryLightGray to: BrGlamorousColors errorBorderColor at: aWeight.
	
	taskElements := aWeight > 0.1
		ifTrue: [
			| myDuration |		
			myDuration := self totalDuration.
	
			self subEvents collect: [ :anEvent |
				| eachWeight |
				
				eachWeight := myDuration isZero
					ifTrue: [ 0 ]
					ifFalse: [ (anEvent totalDuration / myDuration) asFloat ].
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

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtClonerSignalsFor: aView [
	<gtView>
	^ aView forward
		title: 'Cloner signals' translated;
		priority: 30;
		object: [ clonerEvent ];
		view: #gtViewLocalSignalsFor:
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtLoadDirectivesDetailedMapFor: aView [
	"<gtView>"
	^ aView mondrian
		title: 'Load map' translated;
		priority: 20;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aSubgroup |
					BrVerticalPane new
						fitContent;
						alignCenter;
						border: (BlBorder paint: Color gray);
						padding: (BlInsets all: 3);
						geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aSubgroup ];
						addChild: (BrLabel new 
							text: aSubgroup baselineName; 
							aptitude: BrGlamorousLabelAptitude);
						addChild: (BrLabel new 
							text: aSubgroup totalDuration gtHumanReadableString; 
							aptitude: BrGlamorousLabelAptitude) ];
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
			"mondrian layout custom: (GtGradWestHierarchicalLayout new)"
			mondrian layout  horizontalDominanceTree
				levelDistance: 200;
				nodeDistance: 10 ]
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Load map' translated;
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
			"mondrian layout custom: (GtGradWestHierarchicalLayout new)"
			mondrian layout  horizontalDominanceTree
				levelDistance: 100;
				nodeDistance: 10 ]
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtMapFor: aView [
	<gtView>

	^ aView explicit
		title: 'Duration map';
		priority: 20;
		stencil: [ self gtBarElements ]
]

{ #category : #'gt-extensions' }
GtRlLoadedConsolidatedBaselineEvent >> gtViewLoaderEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Loader events';
		items: [ loaderEvents ];
		column: 'Timestamp' text: [ :anEvent | anEvent completedSignal timestamp asString ];
		column: 'Action Type' text: [ :anEvent | anEvent actionType ];
		column: 'Action Description' text: [ :anEvent | anEvent actionDescription ];
		column: 'Duration' text: [ :anEvent | anEvent duration ]
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> gtViewOverviewFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Overview';
		items: [ self overviewData ];
		"expandUpTo: 2;"
		children: [ :assoc | 
			assoc value isDictionary 
				ifTrue: [ assoc value at: 'children' ]
				ifFalse: [ #() ] ];
		column: 'Property' text: [ :assoc | 
			assoc key ];
		column: 'Value' text: [ :assoc |
			assoc value isDictionary 
				ifTrue: [ assoc value at: 'value' ]
				ifFalse: [ assoc value ] ]
]

{ #category : #'gt-extensions' }
GtRlLoadedConsolidatedBaselineEvent >> gtViewSubEventsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Baselines (tree)';
		priority: 10;
		items: [ {self} ];
		children: #subEvents;
		column: 'Baseline' text: #baselineName;
		column: 'Total Duration' 
			text: [ :aGroup | aGroup totalDuration ];
		column: 'Local Duration' 
			text: [ :aGroup | aGroup localDuration ]
]

{ #category : #initialization }
GtRlLoadedConsolidatedBaselineEvent >> initialize [ 
	super initialize.
	subEvents := OrderedCollection new.
	loaderEvents := GtRlLoaderEventsGroup new. 
]

{ #category : #initialization }
GtRlLoadedConsolidatedBaselineEvent >> initializeFrom: aClonerEvent [
	clonerEvent := aClonerEvent.
	aClonerEvent subEvents do: [ :anotherClonerEvent |
		| newEvent |
		newEvent := self class new.
		self addSubEvent: newEvent.
		newEvent initializeFrom: anotherClonerEvent ]
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> loaderEvents: aGroup [
	loaderEvents := aGroup 
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> localDuration [
	^ self clonerEvent localLoadDuration + self localLoaderDuration
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> localLoaderDuration [
	loaderEvents size = 0 ifTrue: [ ^ 0 seconds ].
	^ loaderEvents totalDuration
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> overviewData [
	^ {
		'Total Loading Time' -> {
			'value' -> self totalDuration.
			'children' -> { 
				'Project Loading Time' ->  self localDuration.
				'Dependencies Loading Time' ->  (self totalDuration - self localDuration )
		 }} asDictionary.
		'Cloner Loading Time' -> {
			'value' -> clonerEvent totalLoadDuration.
			'children' -> {
				'Local Loading Time' -> clonerEvent localLoadDuration.
				'Dependencies Loading Time' -> (clonerEvent totalLoadDuration - clonerEvent localLoadDuration)
		}} asDictionary.
		'Loader Loading Time' -> {
			'value' -> self totalLoaderDuration.
			'children' -> {
				'Local Loading Time' -> self localLoaderDuration.
				'Dependencies Loading Time' -> (self totalLoaderDuration - self localLoaderDuration )
		}} asDictionary
	}
]

{ #category : #printing }
GtRlLoadedConsolidatedBaselineEvent >> printOn: stream [
	super printOn: stream.
	stream 
		nextPutAll: '('.
	self descriptionOn: stream.
	stream
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> subEvents [
	^ subEvents
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> totalDuration [
	
	^ self clonerEvent totalLoadDuration + self totalLoaderDuration
]

{ #category : #accessing }
GtRlLoadedConsolidatedBaselineEvent >> totalLoaderDuration [
	| duration |
	duration := 0 seconds.
	self withDeep: #subEvents do: [ :anEvent |
		duration := duration + anEvent localLoaderDuration ].
	^ duration
]
