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
GtRlReleaseUpdateWorkflow >> repositoriesInReleaseOrderFor: aRepositoryRelease [
	^ GtRlReleaseOrderTraversal new releaseOrderFor: aRepositoryRelease
]

{ #category : #updating }
GtRlReleaseUpdateWorkflow >> updateProject: aRootProjectRelease [
	self updateRepository: aRootProjectRelease repositoryRelease
]

{ #category : #updating }
GtRlReleaseUpdateWorkflow >> updateRepository: aRootRepositoryRelease [
	| repositories |
	repositories := self repositoriesInReleaseOrderFor: aRootRepositoryRelease.
	repositories do: [ :aRepositoryRelease | 
		aRepositoryRelease releaseStrategy 
			updateFor: self;
			updateReleaseActionsUsing: self ].
	repositories do: [ :aRepositoryRelease | 
		aRepositoryRelease releaseStrategy updatePostBuildActionsUsing: self ]. 
]
