Class {
	#name : #WfJobRunStageSelfStageFlowNodeLog,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'hasMore',
		'nodeStatus',
		'length',
		'consoleUrl',
		'nodeId',
		'text',
		'startTimeMillis',
		'name',
		'id',
		'pauseDurationMillis',
		'parentNodes',
		'status',
		'parameterDescription',
		'execNode',
		'durationMillis',
		'error'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageSelfStageFlowNodeLog >> text [
	^ text
]
