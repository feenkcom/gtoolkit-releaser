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
		'id',
		'_parent',
		'error',
		'_self'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStage >> getDescribe [
	|describeURL json|
	^ self getLinks
]

{ #category : #accessing }
WfJobRunStage >> gtNodes: aView [
	<gtView>
	^ aView columnedList
		title: 'Nodes' translated;
		priority: 10;
		items: [ self nodes ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ];
		column: 'Parameter' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job parameterDescription ]; 
				matchParent ]
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
	^ _self stageFlowNodes
]

{ #category : #accessing }
WfJobRunStage >> status [
	^ status
]
