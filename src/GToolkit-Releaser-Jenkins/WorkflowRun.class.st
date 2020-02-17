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
WorkflowRun >> getTheConsoleText [
	consoleText := self znclient get: ('' join: { self url . '/consoleText'}).
	^ consoleText
]

{ #category : #accessing }
WorkflowRun >> gtFailureReasonFor: aView [
	<gtView>
	_result = 'FAILURE' ifTrue:[
	^ aView textEditor
		title: 'Why did it fail';
		text: self reasonForFailure.
		].
	^ aView empty
		
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
WorkflowRun >> reasonForFailure [
	|text startIndex lineNumber|
	text := self consoleText.
	startIndex := text findString: 'Pharo VM version:'.
	lineNumber := text lineNumberCorrespondingToIndex: startIndex .
	^ String lf join:(text lines copyFrom: lineNumber - 20 to: (text lines size)).

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
