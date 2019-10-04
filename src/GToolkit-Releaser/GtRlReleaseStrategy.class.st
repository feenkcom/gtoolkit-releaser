"
I model a strategy for executing a repository release.

My main responsabilities consist in updating a repository release by computing and setting its version number and creating the necessary release actions. I add release actions to both the repository release and its project releases. The API method that does the update of a repository release is ${method:GtRlReleaseStrategy>>#updateFor:}$.

I should be initialized based on a ${class:GtRlReleaseConfiguration}$ instance used to configure various aspects of the release process.

Some of my subclasses include:

${class:GtRlBaselineTagReleaseStrategy}$ a release strategy that uses the current loaded tag for a repository as the version number. 

${class:GtRlHeadCommitReleaseStrategy}$ a release strategy that uses the id of the head commit as the version number.

${class:GtRlDedicatedBranchReleaseStrategy}$ a release strategy that uses a dedicated release branch for creating the release.
"
Class {
	#name : #GtRlReleaseStrategy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	"I assert if the given repository can be handled by the strategy."
]

{ #category : #printing }
GtRlReleaseStrategy >> description [
	self subclassResponsibility
]

{ #category : #'actions - building' }
GtRlReleaseStrategy >> findNewCommits [
	^ nil.
]

{ #category : #ui }
GtRlReleaseStrategy >> gtCommitsAncestryFor: aView [
	^ aView
]

{ #category : #initialization }
GtRlReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aBuildConfiguration [
	self assertCompatibleWithRepository: aRepositoryRelease repository. 
	
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
