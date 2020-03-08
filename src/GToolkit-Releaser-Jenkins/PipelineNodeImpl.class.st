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
		'_displayName',
		'parentRun'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
PipelineNodeImpl >> failedTests [
	|allFailed|
	allFailed := parentRun tests select: [:each | each isFailed].
	allFailed := allFailed select: [:t | t testNameParsed size = 4 and: [(t testNameParsed at: 3) trimmed asSymbol = self name asSymbol]].
	^ allFailed
]

{ #category : #accessing }
PipelineNodeImpl >> gtDisplayOn: stream [
	stream nextPutAll: _displayName
]

{ #category : #accessing }
PipelineNodeImpl >> gtFailedTestsFor: aView [
	<gtView>
	| ft|
	ft := self failedTests.
	ft isEmpty ifTrue:[ ^ aView empty].
	^ aView columnedList
		title: 'FailedTests' translated;
		priority: 60;
		items: [ self failedTests];
		column: 'Index' translated item: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray] width: 20;
		column: 'Status' translated do: [ :column | 
			column
				itemStencil: [ :each | BlElement new geometry: BlCircle new; background: each statusBackgroundColor; size: 10@10; margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
				noResize ];
		column: 'Class' translated format: [ :eachItem | eachItem testClassName] width: 250;
		column: 'Method' translated format: [ :eachItem | eachItem testMethodName]
]

{ #category : #accessing }
PipelineNodeImpl >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps' translated;
		priority: 50;
		items: [ self steps];
		column: 'Status' translated do: [ :column | 
			column
				itemStencil: [ :each | BlElement new geometry: BlCircle new; background: each resultBackgroundColor; size: 10@10; margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
				noResize ];
		column: 'Item' translated format: [ :eachItem | eachItem gtDisplayText ]
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
PipelineNodeImpl >> parentRun: aRun [
	parentRun := aRun
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
PipelineNodeImpl >> resultBackgroundColor [
	^ JenkinsClient backgroundColorForStatus: self result
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
