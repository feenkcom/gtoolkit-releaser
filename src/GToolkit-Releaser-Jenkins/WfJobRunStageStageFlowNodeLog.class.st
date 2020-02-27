Class {
	#name : #WfJobRunStageStageFlowNodeLog,
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
		'pauseDurationMillis',
		'parentNodes',
		'status',
		'parameterDescription',
		'execNode',
		'durationMillis'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageStageFlowNodeLog >> text [ 
	^ text
	
]
