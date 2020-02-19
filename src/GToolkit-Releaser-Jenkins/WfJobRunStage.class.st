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
WfJobRunStage >> gtLog: aView [
	<gtView>
		^ aView textEditor
		title: 'Console Log';
		text: [self log]
]

{ #category : #accessing }
WfJobRunStage >> log [
	|logURL|
	logURL := _links at:#self at:#href.
	^ logURL
	"^ znclient get:logURL"
]
