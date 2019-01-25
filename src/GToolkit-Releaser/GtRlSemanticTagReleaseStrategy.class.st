"
I am a release strategy that uses a new tag named based on semantic versioning as the version number.

I mode an active release that needs to execute actions. The actual actions depend on my subclasses however the common ones are:
	- make a new commit and tag it with the version number of this release;
	- push the commit to origin, if a remote origin can be found.
	
I offer the following configuration options: 
	- releaseBranch: the branch on which the release tag will be generated;
	- nextVersionComputation: the logic used to determine the next symbolic version number. See the subclasses of ${class:GtRlSemanticVersionComputation}$ for available options;
	- shouldForceNewRelease: By default I try to detect if a new release is neccessary. This flag indicate that a new release should be forced even if no new changes are detected.

"
Class {
	#name : #GtRlSemanticTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#instVars : [
		'releaseBranchName',
		'nextVersionComputation',
		'shouldForceNewRelease',
		'enforcedVersion'
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
	self repositoryRelease commitAndTagRelease.
	
	self 
		assert: [ iceRepository isModified not ]
		description: 'After committing the changes needed for the release there should be no other changes in the repository'
]

{ #category : #'private - actions' }
GtRlSemanticTagReleaseStrategy >> configureNewVersionRelease [
	| nextVersionNumber |
	nextVersionNumber := self nextVersionComputation nextVersionNumberForRepository: self repositoryRelease repository.
	
	(enforcedVersion isNotNil and:[ nextVersionNumber <= enforcedVersion ]) ifTrue: [ 
		nextVersionNumber := enforcedVersion ].
	
	(GtRlRepositoryActiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: nextVersionNumber) emit.
	self repositoryRelease 
		resetReleaseActions;
		markAsActive;
		version: nextVersionNumber.
		
	
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> enforcedVersion [
	^ enforcedVersion
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> enforcedVersion: aVersion [
	enforcedVersion := aVersion
]

{ #category : #initialization }
GtRlSemanticTagReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		nextVersionComputation: (aReleaseConfiguration releaseVersionComputationForRepository: aRepositoryRelease repository);
		enforcedVersion: aReleaseConfiguration enforcedVersion;
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

{ #category : #testing }
GtRlSemanticTagReleaseStrategy >> shouldCreateNewRelease [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> shouldForceNewRelease [
	^ shouldForceNewRelease
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> shouldForceNewRelease: aBoolean [
	shouldForceNewRelease := aBoolean
]

{ #category : #accessing }
GtRlSemanticTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	| latestVersionTag |
	
	self shouldCreateNewRelease ifTrue: [ 
		^ self configureNewVersionRelease ].
	
	"If a new release is not requires used the latest semantic tag and make the release passive."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber) emit.
	
	"Use the latest releae instead of generating a new one."
	^ self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber;
		makePassiveRelease
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
