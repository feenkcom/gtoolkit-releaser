Class {
	#name : #WfJobRunStageSelfStageFlowNode,
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
		'_parent',
		'console',
		'_self',
		'log',
		'error'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunStageSelfStageFlowNode >> getDescription [
	^ self getLinks
]

{ #category : #accessing }
WfJobRunStageSelfStageFlowNode >> gtLog: aView [
	<gtView>
		^ aView textEditor
		title: 'Console Log';
		text: [self log text]
]

{ #category : #accessing }
WfJobRunStageSelfStageFlowNode >> log [
	self getLinks.
	^ log
]

{ #category : #accessing }
WfJobRunStageSelfStageFlowNode >> name [
 ^ name
]

{ #category : #accessing }
WfJobRunStageSelfStageFlowNode >> parameterDescription [
	^ parameterDescription
]