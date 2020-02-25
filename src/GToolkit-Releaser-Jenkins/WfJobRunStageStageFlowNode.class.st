Class {
	#name : #WfJobRunStageStageFlowNode,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'startTimeMillis',
		'name',
		'id',
		'pauseDurationMillis',
		'parentNodes',
		'status',
		'parameterDescription',
		'execNode',
		'durationMillis',
		'parentIds'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageStageFlowNode >> id [
	^ id
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> parameterDescription [
	^ parameterDescription
]
