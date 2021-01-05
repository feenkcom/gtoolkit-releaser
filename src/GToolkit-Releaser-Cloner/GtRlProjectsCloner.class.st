Class {
	#name : #GtRlProjectsCloner,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'repositoryUrlString',
		'cloneWorkflow',
		'loggersById'
	],
	#category : #'GToolkit-Releaser-Cloner-Core'
}

{ #category : #baselines }
GtRlProjectsCloner >> baseline: aBaselineName [
	self assert: [ aBaselineName notNil and: [ baselineName isNil ] ].
	baselineName := aBaselineName
]

{ #category : #actions }
GtRlProjectsCloner >> execute [ 
	self assert: [ cloneWorkflow isNil ].
	self assert: [ baselineName notNil ].
	self assert: [ repositoryUrlString notNil ].
	
	cloneWorkflow := GtRlProjectsCloneWorkflow new.
	cloneWorkflow initializeIcebergRepos.
	
	self loggers do: [ :aLogger |
		aLogger startFor: GtRlClonerBaselineEvent ].
	[ 
		cloneWorkflow
			loadBaselineSpec: (GtRlClonerBaselineSpec new
				baselineName: baselineName;
				repositoryLocation: repositoryUrlString) 
	] ensure: [
		self loggers do: [ :aLogger | aLogger stop ] ].
	
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewEventsFor: aView [
	<gtView>
	self hasMemoryLogger ifNil: [ ^ aView empty ].
	^ aView columnedList
	 	title: 'Events';
	 	priority: 30;
	 	items: [ self memoryLogger recordings ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewGroupedEventsFor: aView [
	<gtView>
	self hasMemoryLogger ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Events (grouped)';
		priority: 35;
		object: [ GtRlClonerBaselineEventsGroup 
			fromEvents: self memoryLogger recordings  ];
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

{ #category : #testing }
GtRlProjectsCloner >> hasMemoryLogger [
	^ loggersById includesKey: #memoryLogger
]

{ #category : #testing }
GtRlProjectsCloner >> hasTranscriptLogger [
	^ loggersById includesKey: #transcriptLogger
]

{ #category : #initialization }
GtRlProjectsCloner >> initialize [
	super initialize.
	loggersById := OrderedDictionary new.
	self registerMemoryLogger.
	self registerTranscriptLogger.
]

{ #category : #'accessing - logging' }
GtRlProjectsCloner >> loggers [
	^ loggersById values
]

{ #category : #'accessing - logging' }
GtRlProjectsCloner >> memoryLogger [
	^ loggersById at: #memoryLogger
]

{ #category : #configuration }
GtRlProjectsCloner >> registerMemoryLogger [
	self hasMemoryLogger ifTrue: [ ^ self ].
	loggersById
		at: #memoryLogger 
		put: MemoryLogger new
]

{ #category : #configuration }
GtRlProjectsCloner >> registerTranscriptLogger [
	self hasTranscriptLogger ifTrue: [ ^ self ].
	loggersById
		at: #transcriptLogger 
		put: TranscriptLogger new
]

{ #category : #baselines }
GtRlProjectsCloner >> repository: aUrlString [
	self assert: [ aUrlString notNil and: [ repositoryUrlString isNil ] ].
	repositoryUrlString := aUrlString
]

{ #category : #'accessing - logging' }
GtRlProjectsCloner >> transcriptLogger [
	^ loggersById at: #transcriptLogger
]
