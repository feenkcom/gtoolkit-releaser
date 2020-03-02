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
WfJobRunStage >> borderColor [
	self status = 'SUCCESS' ifTrue: [^ Color green].
	self status = 'FAILED' ifTrue: [^ Color red].
	^ Color gray.
]

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
	self nodes isEmpty ifTrue:[ ^ aView empty].
	^ aView pannable
		title: 'Steps';
		stencil: [ self stepsBarChart]
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
	
	^bardata max: [:d | d getLinks. d logSize]
	
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
	pns isNotNil ifTrue: [pns collect: [:each | toDeepCollect add: each ]].
	parentStages := toDeepCollect deepCollectAsSet: [:each | 
		(each class = WfJobRunStage) ifTrue: [each] ifFalse:[ each parentNodes]].
	parentStages := parentStages select:[:each | each class = WfJobRunStage ].
	^parentStages.
	
]

{ #category : #accessing }
WfJobRunStage >> status [
	^ status
]

{ #category : #accessing }
WfJobRunStage >> stepsBarChart [
	|aPlotter barChart theData nodes aMaxPages aBarWidthScale|
	theData := GtPlotterDataGroup new values: self nodes.
	theData := theData labelled: [ :each | each name ].

	aMaxPages := theData inject: 0 intoValues: [ :anAmount :eachValue | anAmount max: (eachValue logSize) ].
	aBarWidthScale := GtPlotterLinearScale new domainFrom: 0 to: aMaxPages.

	barChart := GtPlotterHorizontalBarChart new.
	barChart barLabelWidth: 1.
	barChart barWidthScale: aBarWidthScale.
	barChart barWidthData: [ :eachValue | eachValue logSize].
	barChart amountOfTicks: 4.
	barChart with: theData.
	^barChart
]
