Class {
	#name : #WfJobRunNodeStageFlowNode,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'startTimeMillis',
		'name',
		'pauseDurationMillis',
		'parentNodes',
		'status',
		'parameterDescription',
		'execNode',
		'durationMillis',
		'_parent',
		'console',
		'_self',
		'log',
		'error',
		'hasMore',
		'nodeStatus',
		'length',
		'consoleUrl',
		'nodeId',
		'text',
		'stageFlowNodes'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunNodeStageFlowNode >> name [
	^ name
]
