Class {
	#name : #GtRlProjectReleaseStrategySignal,
	#superclass : #GtReleaserSignal,
	#instVars : [
		'project',
		'strategy'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlProjectReleaseStrategySignal class >> project: aProjectId strategy: aReleaseStrategy [
	^ self new
	  project: aProjectId;
	  strategy: aReleaseStrategy.
]

{ #category : #accessing }
GtRlProjectReleaseStrategySignal >> printOneLineContentsOn: stream [
	stream nextPutAll: project; nextPutAll: ' '; nextPutAll: strategy class name
]

{ #category : #accessing }
GtRlProjectReleaseStrategySignal >> project [
	^ project
]

{ #category : #accessing }
GtRlProjectReleaseStrategySignal >> project: anObject [
	project := anObject
]

{ #category : #accessing }
GtRlProjectReleaseStrategySignal >> strategy [
	^ strategy
]

{ #category : #accessing }
GtRlProjectReleaseStrategySignal >> strategy: anObject [
	strategy := anObject
]
