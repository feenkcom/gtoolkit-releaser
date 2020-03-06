Class {
	#name : #PipelineStepImpl,
	#superclass : #JenkinsURL,
	#instVars : [
		'_displayDescription',
		'_type',
		'_actions',
		'_startTime',
		'_id',
		'_durationInMillis',
		'__links',
		'_input',
		'_result',
		'_state',
		'_displayName'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
PipelineStepImpl >> gtActionsFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: 'Actions' translated;
		priority: 50;
		items: [ _actions].

	aList column
		title: 'Index' translated;
		width: 30;
		item: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray].
	
	aList column
		title: 'Item' translated;
		item: [ :eachItem :eachIndex | eachItem ];
		itemFormat: [ :eachItem | eachItem gtDisplayText ].
	
	^ aList
]

{ #category : #accessing }
PipelineStepImpl >> gtDisplayOn: stream [
	_displayDescription ifNil: [stream nextPutAll: _displayName].
	_displayDescription ifNotNil: [stream nextPutAll: (' ', _displayDescription )]
]

{ #category : #accessing }
PipelineStepImpl >> gtLogFor: aView [
	<gtView>
	|text|
	text := (_actions detect: [:a | a urlName = 'log']) rawLog.
	text ifNil: [^aView empty].
	^ aView textEditor
		look: BrGlamorousCodeEditorLook;
		title: 'Console Log';
		text: [text]
]

{ #category : #accessing }
PipelineStepImpl >> result [
	^ _result
]
