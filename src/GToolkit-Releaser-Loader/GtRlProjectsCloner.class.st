Class {
	#name : #GtRlProjectsCloner,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'repositoryUrlString',
		'cloneWorkflow',
		'memoryLogger'
	],
	#category : #'GToolkit-Releaser-Loader'
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
	
	memoryLogger := MemoryLogger new.
	memoryLogger startFor: GtRlClonerBaselineEvent.
	[ cloneWorkflow
		loadBaseline: baselineName 
		fromRepository: repositoryUrlString ] ensure: [
			memoryLogger stop ].
	
]

{ #category : #accessing }
GtRlProjectsCloner >> gtViewEventsFor: aView [
	<gtView>
	memoryLogger ifNil: [ ^ aView empty ].
	^ aView columnedList
	 	title: 'Events';
	 	items: [ memoryLogger recordings ];
	 	column: 'Timestamp' text: [ :aRecording | aRecording timestamp asString ];
	 	column: 'Type' text: [ :aRecording | aRecording eventName ];
	 	column: 'Baseline' text: [ :aRecording | aRecording baselineName ];
	 	column: 'Repository' text: [ :aRecording | aRecording repositoryUrlString ]
]

{ #category : #baselines }
GtRlProjectsCloner >> repository: aUrlString [
	self assert: [ aUrlString notNil and: [ repositoryUrlString isNil ] ].
	repositoryUrlString := aUrlString
]
