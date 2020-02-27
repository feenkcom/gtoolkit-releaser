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
WfJobRunStage >> gtNodes: aView [
	<gtView>
	self nodes isEmpty ifTrue:[ ^ aView empty].
	^ aView columnedList
		title: 'Nodes' translated;
		priority: 20;
		items: [ self nodes ];
		column: 'Script' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job parameterDescription ]; 
				matchParent ];
		column: 'ID' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job id ]; 
				matchParent ]
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
