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
		priority: 60;
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
	  priority: 55; 
	  painting: [ :mondrian | 
	  	  |allNodes|
	  	  allNodes := self nodes.
			mondrian nodes 
				shape: [ :aStage | 
				|container editor statusColor statusElement|
					statusColor := aStage borderColor.
					container := BlElement new
						layout: BlLinearLayout horizontal;
						look:BrShadowLook;
						margin:(BlInsets all:10);
						
						background: Color white;
						zIndex: 1;
						when: BlClickEvent do:[:e | e target phlow spawnObject: aStage];
						constraintsDo: [ :c |
							"c padding: (BlInsets all: 5)."
							c horizontal exact:240.
							c vertical fitContent].
					editor := BrLabel new 
						text: (aStage name asRopedText "copyReplaceAll: String space with: String cr");
						look: BrGlamorousLabelLook;
						constraintsDo: [ :c | 
							c margin: (BlInsets all: 5).
							
							c vertical fitContent.
							c horizontal matchParent.
							 ].
					container
						addChild: (BrVerticalPane new vMatchParent; hExact:15; background: statusColor );
						addChild: (editor).
						"addChild: aStage stepsBarChart asElement."
				];
				
			with: allNodes.
			mondrian edges
				shape: [
					BlSigmoidElement new 
						zIndex: 0;
						beVertical;
						bendingPoint:0.3;
						sharpness: 0.1;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2)
						"toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 10; build)) "];
				fromCenterBottom;
				toCenterTop;
				connectFrom: #yourself 
				toAll: [:each | | pN |
					pN := each nextStagesIds.
					allNodes select: [ :node | pN anySatisfy: [ :stageID | stageID = node id ] ] ].
			mondrian layout custom: ((GtGradNorthHierarchicalLayout new interRanksSpacing: 30)).
			]
]

{ #category : #accessing }
PipelineRunImpl >> gtTestsFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: _runSummary translated;
		priority: 50;
		items: [ self tests].

	aList column
		title: 'Index' translated;
		width: 30;
		item: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray].
	
	aList column
		title: 'Status' translated;
		width: 70;
		item: [ :eachItem :eachIndex | eachItem ];
		itemFormat: [ :eachItem | eachItem status ].
	
	aList column
		title: 'Name' translated;
		item: [ :eachItem :eachIndex | eachItem ];
		itemFormat: [ :eachItem | eachItem gtDisplayText ].
	^ aList
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
PipelineRunImpl >> rawBlueTestsSummary [
		|data|
	data := znclient get: ('' join:{url. __links at:'blueTestSummary' at: 'href'}).
	^ data
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
PipelineRunImpl >> rawTests [
		|data|
	data := znclient get: ('' join:{url. __links at:'tests' at: 'href'}).
	^ (NeoJSONReader fromString: data)
]

{ #category : #accessing }
PipelineRunImpl >> result [
	^ _result
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

{ #category : #accessing }
PipelineRunImpl >> tests [
	|raws codeGenerator| 
	raws := self rawTests.
	codeGenerator := JSONCodeGenerator new.
	^ raws collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]
