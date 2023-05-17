"
I provide then main entry point for cloning a baseline from a repository together with all its dependencies.

My main API for configuring the baseline to clone: 
- {{gtMethod:GtRlProjectsCloner>>#baseline:}}
- {{gtMethod:GtRlProjectsCloner>>#repository:}}

I am a wrapper around {{gtClass:GtRlProjectsCloneWorkflow}} that provides the cloning logic. I add an API for configuring it and logging support.


"
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
		aLogger startFor: GtRlClonerBaselineSignal ].
	[ 
		^ cloneWorkflow
			loadBaselineSpec: (GtRlClonerBaselineSpec new
				baselineName: baselineName;
				repositoryLocation: repositoryUrlString)
	] ensure: [
		self loggers do: [ :aLogger | aLogger stop ] ]
	
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewEventsFor: aView [
	<gtView>
	self hasMemoryLogger ifNil: [ ^ aView empty ].
	^ aView forward
	 	title: 'Events';
	 	priority: 30;
	 	object: [ GtRlClonerSignalsGroup withAll: self memoryLogger recordings ];
	 	view: #gtItemsFor:
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewGroupedEventsFor: aView [
	<gtView>
	self hasMemoryLogger ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Events (grouped)';
		priority: 35;
		object: [ GtRlClonerBaselineEvent 
			fromSignals: self memoryLogger recordings  ];
		view: #gtViewSubEventsFor:
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewLoadedProjectsListFor: aView [
	<gtView>
	cloneWorkflow ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Loaded projects';
		priority: 15;
		object: [ cloneWorkflow ];
		view: #gtViewLoadedProjectsListFor:
]

{ #category : #'gt extensions' }
GtRlProjectsCloner >> gtViewRepositoriesCacheFor: aView [
	<gtView>
	cloneWorkflow ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Repositories cache';
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
