Class {
	#name : #GtRlSemanticTagReleaseStrategy,
	#superclass : #GtRlReleaseStragegy,
	#instVars : [
		'releaseBranchName',
		'nextVersionComputation',
		'shouldForceNewRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #actions }
GtRlSemanticTagReleaseStrategy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #'private - actions' }
GtRlSemanticTagReleaseStrategy >> configureNewVersionReleaseUsing: anUpdateWorkflow [
	| nextVersionNumber |
	nextVersionNumber := self nextVersionComputation nextVersionNumberForRepository: self repositoryRelease repository.
	self repositoryRelease 
		version: nextVersionNumber.
	self updateReleaseActionsUsing: anUpdateWorkflow.
		
	
]

{ #category : #initialization }
GtRlSemanticTagReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		nextVersionComputation: (aReleaseConfiguration releaseVersionComputationForRepository: aRepositoryRelease repository);
		shouldForceNewRelease: aReleaseConfiguration shouldForceNewRelease
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> nextVersionComputation [
	^ nextVersionComputation
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> nextVersionComputation: aVersionComputation [
	nextVersionComputation := aVersionComputation
]

{ #category : #'accessing - dynamic' }
GtRlSemanticTagReleaseStrategy >> releaseBranch [
	^ self repositoryRelease icebergRepository branchNamed: self releaseBranchName 
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> releaseBranchName [
	^ releaseBranchName
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> releaseBranchName: aBranchName [
	releaseBranchName := aBranchName
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> shouldForceNewRelease [
	^ shouldForceNewRelease
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> shouldForceNewRelease: aBoolean [
	shouldForceNewRelease := aBoolean
]

{ #category : #'private - actions' }
GtRlSemanticTagReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	self subclassResponsibility
]
