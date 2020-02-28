Class {
	#name : #WfJobRunStage,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'durationMillis',
		'pauseDurationMillis',
		'status',
		'startTimeMillis',
		'execNode',
		'name',
		'_parent',
		'error',
		'_self',
		'stageFlowNodes',
		'parameterDescription',
		'parentNodes',
		'hasMore',
		'nodeStatus',
		'length',
		'consoleUrl',
		'nodeId',
		'text',
		'log'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStage >> getDescribe [
	|describeURL|
	^ self getParentNodes
]

{ #category : #accessing }
WfJobRunStage >> gtDisplayOn: stream [
	stream nextPutAll: self name.
]

{ #category : #accessing }
WfJobRunStage >> gtNodes: aView [
	<gtView>
	self nodes isEmpty ifTrue:[ ^ aView empty].
	^ aView columnedList
		title: 'Nodes' translated;
		priority: 9;
		items: [ self nodes ];
		column: 'Script' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job parameterDescription ]; 
				matchParent ]
]

{ #category : #accessing }
WfJobRunStage >> gtStepsBarChartFor: aView [
	<gtView>
	^ aView pannable title:'Steps';
			stencil: [
				| aPlotter barChart websiteVisits barData|
				aPlotter := GtPlotter new.
		websiteVisits := GtPlotterHorizontalBarChartBuilderExamples new websiteVisits.
	barData := self nodes.
	barChart := aPlotter horizontalBarChart.
	barChart barStencil: [
		BlElement new
			geometry: BlStadium new;
			margin: (BlInsets top: 4 bottom: 4);
			background: (Color gray alpha: 0.5)].
	barChart barWidthScale: (GtPlotterLinearScale new
		domainFrom: 0 to: ( barData max: #logSize);
		rangeFrom: 10 to: 200).
	barChart barHeightScale: (GtPlotterLinearScale new
		domainFrom: 0 to: 10;
		rangeFrom: 10 to: 50).
	barChart ticks: 2.
	barChart barLabelFormat: [ :eachDataItem | eachDataItem name ].
	barChart barWidthData: [ :eachDataItem | eachDataItem logSize ].
	barChart barHeightData: [ :eachDataItem | 4 ].
	barChart with: barData.

	aPlotter root
			].
]

{ #category : #accessing }
WfJobRunStage >> id [
	^ id
]

{ #category : #accessing }
WfJobRunStage >> log [
	|logURL|
	logURL := _links at:#self at:#href.
	^ logURL
	"^ znclient get:logURL"
]

{ #category : #accessing }
WfJobRunStage >> maxConsoleSize [
	|bardata|
	bardata := self nodes.
	
	^bardata collect: [:d | d log]
	
]

{ #category : #accessing }
WfJobRunStage >> name [
	^ name
]

{ #category : #accessing }
WfJobRunStage >> nodes [
	self getLinks.
	^ stageFlowNodes
]

{ #category : #accessing }
WfJobRunStage >> parentStages [
	|parentStages pns toDeepCollect|
	pns := self parentNodes.
	toDeepCollect := OrderedCollection new.
	pns collect: [:each | toDeepCollect add: each ].
	parentStages := toDeepCollect deepCollectAsSet: [:each | 
		(each class = WfJobRunStage) ifTrue: [each] ifFalse:[ each parentNodes]].
	parentStages := parentStages select:[:each | each class = WfJobRunStage ].
	^parentStages.
	
]

{ #category : #accessing }
WfJobRunStage >> status [
	^ status
]
