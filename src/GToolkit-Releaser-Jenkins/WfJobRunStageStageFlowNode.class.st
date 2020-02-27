Class {
	#name : #WfJobRunStageStageFlowNode,
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
		'parentNode',
		'console',
		'log',
		'_self',
		'error'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageStageFlowNode >> gtDisplayOn: stream [
	^ stream nextPutAll: self name
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> gtTextFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Console Log';
		text: [log text]
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> name [
	^ name
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> parameterDescription [
	^ parameterDescription
]
