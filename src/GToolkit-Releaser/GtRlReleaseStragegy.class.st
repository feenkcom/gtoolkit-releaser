Class {
	#name : #GtRlReleaseStragegy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlReleaseStragegy >> description [
	self subclassResponsibility
]

{ #category : #ui }
GtRlReleaseStragegy >> gtCommitsAncestryFor: aView [
	^ aView
]

{ #category : #initialization }
GtRlReleaseStragegy >> initializeFor: aRepositoryRelease fromConfiguration: aBuildConfiguration [
	self repositoryRelease: aRepositoryRelease.
	aRepositoryRelease releaseStrategy: self.
]

{ #category : #accessing }
GtRlReleaseStragegy >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlReleaseStragegy >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]

{ #category : #accessing }
GtRlReleaseStragegy >> updateFor: anUpdateWorkflow [
	self subclassResponsibility
]
