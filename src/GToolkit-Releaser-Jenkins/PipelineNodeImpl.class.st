Class {
	#name : #PipelineNodeImpl,
	#superclass : #JenkinsURL,
	#instVars : [
		'_displayDescription',
		'_type',
		'_edges',
		'_actions',
		'_restartable',
		'_startTime',
		'_id',
		'_durationInMillis',
		'_causeOfBlockage',
		'_firstParent',
		'__links',
		'_input',
		'_result',
		'_state',
		'_displayName'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
PipelineNodeImpl >> borderColor [
	_result = 'SUCCESS' ifTrue: [^ BrGlamorousColors successBackgroundColor].
	_result = 'FAILED' ifTrue: [^ BrGlamorousColors errorBackgroundColor].
	_result = 'UNSTABLE' ifTrue: [^ JenkinsClient yellow].
	^ BrGlamorousColors lightBorderColor.
]

{ #category : #accessing }
PipelineNodeImpl >> gtDisplayOn: stream [
	stream nextPutAll: _displayName
]

{ #category : #accessing }
PipelineNodeImpl >> gtStepsFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: 'Steps' translated;
		priority: 50;
		items: [ self steps].

	aList column
		title: 'Index' translated;
		width: 30;
		item: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray].
	
	aList column
		title: 'Item' translated;
		item: [ :eachItem :eachIndex | eachItem ];
		itemFormat: [ :eachItem | eachItem gtDisplayText ].
		
	aList column
		title: 'Result' translated;
		width: 70;
		item: [ :eachItem :eachIndex | eachItem result];
		itemFormat: [ :eachItem | eachItem gtDisplayText ].
	
	^ aList
]

{ #category : #accessing }
PipelineNodeImpl >> id [ 
	^ _id
]

{ #category : #accessing }
PipelineNodeImpl >> name [
	^ _displayName
]

{ #category : #accessing }
PipelineNodeImpl >> nextStagesIds [
	^ _edges collect: [:e | e id]
]

{ #category : #accessing }
PipelineNodeImpl >> rawSteps [
|data|
	data := znclient get: ('' join:{url. __links at:'steps' at: 'href'}).
	^ (NeoJSONReader fromString: data)
]

{ #category : #accessing }
PipelineNodeImpl >> result [
	^ _result
]

{ #category : #accessing }
PipelineNodeImpl >> steps [
	|raws codeGenerator| 
	raws := self rawSteps.
	codeGenerator := JSONCodeGenerator new.
	codeGenerator znclient: znclient.
	codeGenerator baseURL:url.
	^ raws collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]
