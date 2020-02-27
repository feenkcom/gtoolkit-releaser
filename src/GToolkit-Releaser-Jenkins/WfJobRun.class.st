Class {
	#name : #WfJobRun,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'startTimeMillis',
		'name',
		'stages',
		'pauseDurationMillis',
		'status',
		'queueDurationMillis',
		'endTimeMillis',
		'durationMillis',
		'_self',
		'changesets',
		'nodesDictionary'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRun >> allNodes [
	|parents|
	parents:=stages deepCollectAsSet: [:each | each parentNodes ].
	(parents addAll:stages) asSet.
	^ parents.
]

{ #category : #accessing }
WfJobRun >> gtStagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Stages' translated;
		priority: 10;
		items: [ stages ];
		column: 'Name' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job name ]; 
				matchParent ];
		column: 'Status' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job status ]; 
				matchParent ];
		column: 'ID' translated do: [ :aColumn | 
			aColumn 
				item: [ :job | job id ]; 
				matchParent ]
]

{ #category : #accessing }
WfJobRun >> gtStagesMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Stages Map' translated;
	  priority: 10; 
	  painting: [ :mondrian | 
	  	  |allNodes|
	  	  allNodes := self allNodes.
			mondrian nodes 
				shape: [ :aStage | 
				|container children label  |
					
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					label := BlTextElement new
						text: (aStage name asRopedText );
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					container
						addChild: label.
				];
				
			with: allNodes.
			mondrian edges
				shape: [
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.1;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						fromHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build)) ];
				fromLeftCenter;
				toRightCenter;
				connectFrom: #yourself 
				toAll: [:each | | parentNodes |
					parentNodes := each parentNodes.
					allNodes select: [ :node | parentNodes anySatisfy: [ :parentNode | parentNode id = node id ] ] ].
			mondrian layout custom: (GtGradEastHierarchicalLayout new).
			]
]

{ #category : #accessing }
WfJobRun >> initialize [
	nodesDictionary := Dictionary new.
]

{ #category : #accessing }
WfJobRun >> name [
	^ name
]

{ #category : #accessing }
WfJobRun >> nodeWithId: anId [
	^ nodesDictionary at:anId ifAbsent: [^ nil].
]

{ #category : #accessing }
WfJobRun >> registerNode: aJenkinsWFAPI [
	nodesDictionary at:aJenkinsWFAPI id put: aJenkinsWFAPI.
]

{ #category : #accessing }
WfJobRun >> status [
	^ status
]
