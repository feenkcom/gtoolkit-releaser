Class {
	#name : #WfJobRunNode,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'durationMillis',
		'pauseDurationMillis',
		'status',
		'startTimeMillis',
		'execNode',
		'name',
		'_self',
		'parentNode',
		'parentNodes',
		'parameterDescription',
		'stageFlowNodes',
		'hasMore',
		'nodeStatus',
		'length',
		'consoleUrl',
		'nodeId',
		'text',
		'error',
		'log'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunNode >> gtDisplayOn: stream [
	stream nextPutAll: self name.
]

{ #category : #accessing }
WfJobRunNode >> name [
	^ name
]
