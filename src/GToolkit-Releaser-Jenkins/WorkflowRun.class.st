Class {
	#name : #WorkflowRun,
	#superclass : #JenkinsURL,
	#instVars : [
		'_parent',
		'_result',
		'_url',
		'_timestamp',
		'_id',
		'consoleText'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-OrgJenkinsciPluginsWorkflowJob'
}

{ #category : #accessing }
WorkflowRun >> consoleText [
	
	consoleText ifNil:[
		consoleText := self znclient get: ('' join: { self url . '/consoleText'}).
	].
	^ consoleText
]

{ #category : #accessing }
WorkflowRun >> gtTextFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Console Log';
		text: [self consoleText]
]

{ #category : #accessing }
WorkflowRun >> name [
	^ _id
]

{ #category : #accessing }
WorkflowRun >> result [
	^ _result
]

{ #category : #accessing }
WorkflowRun >> url [
	^ _url
]

{ #category : #accessing }
WorkflowRun >> znclient [ 
	^ _parent znclient 
]
