Class {
	#name : #PipelineRunImpl,
	#superclass : #JenkinsURL,
	#instVars : [
		'_actions',
		'_enQueueTime',
		'_result',
		'_runSummary',
		'_branch',
		'_changeSet',
		'_commitId',
		'_commitUrl',
		'_pullRequest',
		'_name',
		'_type',
		'_endTime',
		'_causeOfBlockage',
		'_durationInMillis',
		'_artifactsZipFile',
		'_estimatedDurationInMillis',
		'_organization',
		'_startTime',
		'__links',
		'_pipeline',
		'_description',
		'_state',
		'_causes',
		'_id',
		'_replayable'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
PipelineRunImpl >> gtDisplayOn: stream [
	stream nextPutAll: _id
]

{ #category : #accessing }
PipelineRunImpl >> gtNodesFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: 'Nodes' translated;
		priority: 50;
		items: [ self nodes].

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
PipelineRunImpl >> gtStagesMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Stages Map' translated;
	  priority: 10; 
	  painting: [ :mondrian | 
	  	  |allNodes|
	  	  allNodes := self nodes.
			mondrian nodes 
				shape: [ :aStage | 
				|container label statusColor|
					statusColor := aStage borderColor.
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: statusColor width:2);
						zIndex: 1;
						when: BlClickEvent do:[:e | e target phlow spawnObject: aStage];
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					label := BlTextElement new
						text: (aStage name asRopedText);
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					container
						addChild: label
						"addChild: aStage stepsBarChart asElement."
				];
				
			with: allNodes.
			mondrian edges
				shape: [
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						fromHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | | pN |
					pN := each nextStagesIds.
					allNodes select: [ :node | pN anySatisfy: [ :stageID | stageID = node id ] ] ].
			mondrian layout custom: (GtGradWestHierarchicalLayout new).
			]
]

{ #category : #accessing }
PipelineRunImpl >> nodes [
	|raws codeGenerator| 
	raws := self rawNodes.
	codeGenerator := JSONCodeGenerator new.
	^ raws collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]

{ #category : #accessing }
PipelineRunImpl >> rawNodes [
		|data|
	data := znclient get: ('' join:{url. __links at:'nodes' at: 'href'}).
	^ (NeoJSONReader fromString: data)
	
]

{ #category : #accessing }
PipelineRunImpl >> rawSteps [
		|data|
	data := znclient get: ('' join:{url. __links at:'steps' at: 'href'}).
	^ (NeoJSONReader fromString: data)
	
]

{ #category : #accessing }
PipelineRunImpl >> steps [
	|raws codeGenerator| 
	raws := self rawSteps.
	codeGenerator := JSONCodeGenerator new.
	^ raws collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]
