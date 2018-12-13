Class {
	#name : #GtRlReleaseUpdateWorkflow,
	#superclass : #Object,
	#instVars : [
		'actionOrder'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #initialization }
GtRlReleaseUpdateWorkflow >> initialize [
	super initialize.
	actionOrder := 0
]

{ #category : #'accessing - dynamic' }
GtRlReleaseUpdateWorkflow >> nextActionOrder [
	^ actionOrder := actionOrder + 1
]

{ #category : #'accessing - dynamic' }
GtRlReleaseUpdateWorkflow >> repositoriesInReleaseOrderFor: aProjectRelease [
	^ (aProjectRelease repositoryRelease withDeepCollect: #childRepositoryReleases) reversed
]

{ #category : #updating }
GtRlReleaseUpdateWorkflow >> update: aProjectRelease [
	| repositories |
	repositories := self repositoriesInReleaseOrderFor: aProjectRelease.
	repositories do: [ :aRepositoryRelease | 
		aRepositoryRelease releaseStrategy 
			updateFor: self;
			updateReleaseActionsUsing: self ].
	repositories do: [ :aRepositoryRelease | 
		aRepositoryRelease releaseStrategy updatePostBuildActionsUsing: self ].
]
