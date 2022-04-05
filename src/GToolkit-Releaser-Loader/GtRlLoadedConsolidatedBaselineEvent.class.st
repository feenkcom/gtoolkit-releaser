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
GtRlLoadedConsolidatedBaselineEvent >> gtClonerSignalsFor: aView [
	<gtView>
	^ aView forward
		title: 'Cloner Signals' translated;
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

{ #category : #'gt-extensions' }
GtRlLoadedConsolidatedBaselineEvent >> gtViewLoaderEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Loader Events';
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
