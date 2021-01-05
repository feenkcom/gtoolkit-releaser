Class {
	#name : #GtRlProjectsCloner,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'repositoryUrlString',
		'cloneWorkflow',
		'memoryLogger'
	],
	#category : #'GToolkit-Releaser-Cloner-Core'
}

{ #category : #baselines }
GtRlProjectsCloner >> baseline: aBaselineName [
	self assert: [ aBaselineName notNil and: [ baselineName isNil ] ].
	baselineName := aBaselineName
]

{ #category : #copying }
GtRlProjectsCloner >> execute [ 
	self assert: [ cloneWorkflow isNil ].
	self assert: [ baselineName notNil ].
	self assert: [ repositoryUrlString notNil ].
	
	cloneWorkflow := GtRlProjectsCloneWorkflow new.
	cloneWorkflow initializeIcebergRepos.
	
	memoryLogger := MemoryLogger new.
	memoryLogger startFor: GtRlClonerBaselineEvent.
	[ 
		cloneWorkflow
			loadBaselineSpec: (GtRlClonerBaselineSpec new
				baselineName: baselineName;
				repositoryLocation: repositoryUrlString) 
	] ensure: [
			memoryLogger stop ].
	
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewEventsFor: aView [
	<gtView>
	memoryLogger ifNil: [ ^ aView empty ].
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ memoryLogger recordings ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewGroupedEventsFor: aView [
	<gtView>
	memoryLogger ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Events (grouped)';
		priority: 35;
		object: [ GtRlClonerBaselineEventsGroup 
			fromEvents: memoryLogger recordings  ];
		view: #gtViewSubgroupsFor:
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewLoadedProjectsListFor: aView [
	<gtView>
	cloneWorkflow ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Loaded Projects';
		priority: 15;
		object: [ cloneWorkflow ];
		view: #gtViewLoadedProjectsListFor:
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewRepositoriesCacheFor: aView [
	<gtView>
	cloneWorkflow ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Repositories Cache';
		priority: 20;
		object: [ cloneWorkflow ];
		view: #gtViewRepositoriesCacheFor:
]

{ #category : #baselines }
GtRlProjectsCloner >> repository: aUrlString [
	self assert: [ aUrlString notNil and: [ repositoryUrlString isNil ] ].
	repositoryUrlString := aUrlString
]
