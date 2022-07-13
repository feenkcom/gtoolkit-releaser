Class {
	#name : #GtRlLoaderEventsGroup,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #'instance creation' }
GtRlLoaderEventsGroup class >> fromContents: aLoadingStringLog [
	| loaderSignals |
	loaderSignals := GtRlLoaderSignalsLogReader readFrom:  aLoadingStringLog.
	
	^ self fromSignals: loaderSignals
]

{ #category : #'instance creation' }
GtRlLoaderEventsGroup class >> fromSignals: aGroupOfSignals [
	| eventGroup |
	eventGroup := self new.
	aGroupOfSignals items pairsDo: [ :startSignal :endSignal |
		eventGroup add: (GtRlLoaderActionExecutedEvent new
				startedSignal: startSignal;
				completedSignal: endSignal) ].
	^ eventGroup
]

{ #category : #'instance creation' }
GtRlLoaderEventsGroup class >> withAll: aCollection [
	^ self new
		initializeWith: aCollection
]

{ #category : #adding }
GtRlLoaderEventsGroup >> add: anEvent [
	self items add: anEvent
]

{ #category : #converting }
GtRlLoaderEventsGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> at: anIndex [
	^ self items at: anIndex
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> groupedByBaseline [
	| groups |
	groups := self items groupedBy: [ :anEvent | anEvent baselineName ].
	^ (groups associations collect: [ :assoc |
		assoc key -> (self class withAll: assoc value) ]) asOrderedDictionary 
]

{ #category : #ui }
GtRlLoaderEventsGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ self items ];
	 	column: 'Timestamp' text: [ :anEvent | anEvent completedSignal timestamp asString ];
	 	column: 'Type' text: [ :anEvent | anEvent className ];
	 	column: 'Baseline' text: [ :anEvent | anEvent baselineName ];
	 	column: 'Action Type' text: [ :anEvent | anEvent actionType ];
	 	column: 'Action Description' text: [ :anEvent | anEvent actionDescription ];
	 	column: 'Duration' text: [ :anEvent | anEvent duration ]
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> gtViewByBaselineEventFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'By Baseline';
		items: [ self groupedByBaseline  associations ];
		column: 'Baseline' text: [ :assoc | assoc key ];
		column: 'Events count' text: [ :assoc | assoc value size ];
		column: 'Duration' text: [ :assoc | assoc value totalDuration ];
		send: [ :each | each value ]
]

{ #category : #initialization }
GtRlLoaderEventsGroup >> initialize [ 
	super initialize.
	items := OrderedCollection new.
]

{ #category : #initialization }
GtRlLoaderEventsGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> items [
	^ items
]

{ #category : #printing }
GtRlLoaderEventsGroup >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(';
		print: self items size;
		<< ' events';
		<< ', ';
		print: self totalDuration;
		<< ')'
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> size [
	^ self items size
]

{ #category : #accessing }
GtRlLoaderEventsGroup >> totalDuration [
	^ self items sum: #duration
]
