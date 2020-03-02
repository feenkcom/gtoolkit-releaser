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
	^ stream nextPutAll:self parameterDescription
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> gtTextFor: aView [
	<gtView>
	log isNil ifTrue: [self getLinks].
	^ aView textEditor
		title: 'Console Log';
		text: [log text]
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> log [
	^ log
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> logSize [
	self log ifNil:[self getLinks].
	self log ifNotNil: [
		self log isString ifFalse:[
		self log text ifNil: [self log getLinks].
	self log text ifNotNil: [^ self log text lineCount]]].
	^ 1
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> name [
	^ name
]

{ #category : #accessing }
WfJobRunStageStageFlowNode >> parameterDescription [
	^ parameterDescription
]
