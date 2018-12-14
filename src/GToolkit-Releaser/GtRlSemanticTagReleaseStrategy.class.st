Class {
	#name : #GtRlSemanticTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
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
GtRlSemanticTagReleaseStrategy >> configureNewVersionRelease [
	| nextVersionNumber |
	nextVersionNumber := self nextVersionComputation nextVersionNumberForRepository: self repositoryRelease repository.
	self repositoryRelease 
		resetReleaseActions;
		markAsActive;
		version: nextVersionNumber.
		
	
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

{ #category : #'actions - building' }
GtRlSemanticTagReleaseStrategy >> updatePostBuildActionsUsing: anUpdateWorkflow [
	| pushAction |
	self repositoryRelease isPassiveRelease ifTrue: [ ^ self ].
	
	self repositoryRelease hasRemoteOrigin ifTrue: [
		pushAction := GtRlPushToOriginReleaseAction new
			repositoryRelease: self repositoryRelease;
	 		order: anUpdateWorkflow nextActionOrder.
		self repositoryRelease addReleaseAction: pushAction ]
]
