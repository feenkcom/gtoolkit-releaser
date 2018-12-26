Class {
	#name : #GtRlReleaseStrategy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlReleaseStrategy >> description [
	self subclassResponsibility
]

{ #category : #ui }
GtRlReleaseStrategy >> gtCommitsAncestryFor: aView [
	^ aView
]

{ #category : #initialization }
GtRlReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aBuildConfiguration [
	self repositoryRelease: aRepositoryRelease.
	aRepositoryRelease releaseStrategy: self.
]

{ #category : #testing }
GtRlReleaseStrategy >> isNullReleaseStrategy [
	^ false
]

{ #category : #accessing }
GtRlReleaseStrategy >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlReleaseStrategy >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]

{ #category : #accessing }
GtRlReleaseStrategy >> updateFor: anUpdateWorkflow [
	self subclassResponsibility
]

{ #category : #'actions - building' }
GtRlReleaseStrategy >> updatePostBuildActionsUsing: anUpdateWorkflow [
	"By default do nothing. Subclasses should implement this to create actions."
]

{ #category : #'actions - building' }
GtRlReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	"By default do nothing. Subclasses should implement this to create actions."
]
