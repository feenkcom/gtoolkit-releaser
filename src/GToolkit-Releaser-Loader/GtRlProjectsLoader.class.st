Class {
	#name : #GtRlProjectsLoader,
	#superclass : #Object,
	#instVars : [
		'loggersById'
	],
	#category : #'GToolkit-Releaser-Loader-Core'
}

{ #category : #actions }
GtRlProjectsLoader >> cloneBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| projectCloner |
	projectCloner := GtRlProjectsCloner new.
	projectCloner 
		baseline: aBaselineName;
		repository: aRepositoryLocationString.
	^ projectCloner execute
]

{ #category : #testing }
GtRlProjectsLoader >> hasMemoryLogger [
	^ loggersById includesKey: #memoryLogger
]

{ #category : #testing }
GtRlProjectsLoader >> hasTranscriptLogger [
	^ loggersById includesKey: #transcriptLogger
]

{ #category : #initialization }
GtRlProjectsLoader >> initialize [
	super initialize.
	loggersById := OrderedDictionary new.
	self registerTranscriptLogger.
]

{ #category : #actions }
GtRlProjectsLoader >> loadBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| clonedProject |
	
	self loggers do: [ :aLogger |
		aLogger startFor: GtRlClonerBaselineSignal, GtRlLoaderDirectiveActionSignal ].
	
	[
		clonedProject := self 
			cloneBaseline: aBaselineName 
			fromRepository: aRepositoryLocationString.
		self 
			loadBaselineClass: clonedProject baselineClass
			fromRepository: clonedProject repository loadSpecificationString 
	] ensure: [
		self loggers do: [ :aLogger | aLogger stop ] ]
]

{ #category : #actions }
GtRlProjectsLoader >> loadBaselineClass: aBaselineClass fromRepository: aRepositoryLocationString [
	| rootProject |
	rootProject := aBaselineClass
		gtRlProjectWithRepository: aRepositoryLocationString.
	
	self loadFullProject: rootProject
]

{ #category : #actions }
GtRlProjectsLoader >> loadFullProject: aRootProject [
	| structureBuilder loadDirective loadWorkflow |
	structureBuilder := GtRlLoadDirectiveStructureBuilder new.
	loadDirective := structureBuilder 
		buildLoadDirectiveForProject: aRootProject.
	
	loadWorkflow := GtRlProjectsLoadWorkflow new
		rootLoadDirective: loadDirective.
	loadWorkflow executeLoadActions.
	
	^ loadWorkflow
]

{ #category : #accessing }
GtRlProjectsLoader >> loggers [
	^ loggersById values
]

{ #category : #'accessing - logging' }
GtRlProjectsLoader >> memoryLogger [
	^ loggersById at: #memoryLogger
]

{ #category : #configuration }
GtRlProjectsLoader >> registerMemoryLogger [
	self hasMemoryLogger ifTrue: [ ^ self ].
	loggersById
		at: #memoryLogger 
		put: MemoryLogger new
]

{ #category : #configuration }
GtRlProjectsLoader >> registerTranscriptLogger [
	self hasTranscriptLogger ifTrue: [ ^ self ].
	loggersById
		at: #transcriptLogger 
		put: TranscriptLogger new
]
