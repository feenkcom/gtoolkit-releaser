Class {
	#name : #WfJobRunStageSelf,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'durationMillis',
		'pauseDurationMillis',
		'status',
		'stageFlowNodes',
		'startTimeMillis',
		'execNode',
		'name',
		'id',
		'error'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageSelf >> stageFlowNodes [
	^ stageFlowNodes
]