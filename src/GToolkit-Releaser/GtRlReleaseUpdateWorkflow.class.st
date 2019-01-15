"
I update the version number and release actions for all repository and project releases contained within a give root release.

I use ${class:GtRlReleaseOrderTraversal}$ to determine the other in which repository releases should be updated. For each release I update its order and its actions using the release strategy associated with that release. See ${method:GtRlReleaseUpdateWorkflow>>#updateRepository:}$ for implementation details about how releases are updated.

A relevant detail is that I keep track of the order attribute that should be associated to the next release action. The release strategy should call ${GtRlReleaseUpdateWorkflow>>#nextActionOrder}$ to determine the order of a created action within this update workflow. I do this so that it is possible, just by looking at an action to know when it will be executed during the release. This can help debugging given that each release stores its actions.
"
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
