Class {
	#name : #GtRlSemanticTagReleaseStrategy,
	#superclass : #GtRlReleaseStragegy,
	#instVars : [
		'referenceBranchName',
		'nextVersionComputation',
		'shouldForceNewRelease'
	],
	#category : #'GToolkit-Releaser'
}

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
		referenceBranchName: aRepositoryRelease icebergRepository branchName;
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
GtRlSemanticTagReleaseStrategy >> referenceBranch [
	^ self repositoryRelease icebergRepository branchNamed: self referenceBranchName 
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> referenceBranchName [
	^ referenceBranchName
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> referenceBranchName: aBranchName [
	referenceBranchName := aBranchName
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
