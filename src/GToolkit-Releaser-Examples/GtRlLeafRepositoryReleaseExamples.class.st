Class {
	#name : #GtRlLeafRepositoryReleaseExamples,
	#superclass : #GtRlReleaserExamples,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
GtRlLeafRepositoryReleaseExamples >> assertDefaultInitForRepositoryRelease: repositoryRelease [
	"I assert that a newly created repository release is properly initialized."
	self assert: repositoryRelease version equals: GtRlNullVersionNumber new.
	self assert: repositoryRelease releaseStrategy isNullReleaseStrategy. 
	self assert: repositoryRelease isPassiveRelease description: 'Before the release is updated it should be passive'.
	self assert: repositoryRelease releaseActions isEmpty description: 'There should be no actions as the release is not updated'.
]

{ #category : #assertions }
GtRlLeafRepositoryReleaseExamples >> assertExecutedActions: releaseActions [
	releaseActions do: [ :aReleaseAction |
		self assert: aReleaseAction isExecuted  ]
]

{ #category : #assertions }
GtRlLeafRepositoryReleaseExamples >> assertReleaseActions: aRelease equalTypes: expectedActionTypesWithOrder [
	| obtainedActions |
	obtainedActions := aRelease releaseActions actions.
	self assert: obtainedActions size equals: expectedActionTypesWithOrder size.
	expectedActionTypesWithOrder withIndexDo: [ :actionData :index |
		| obtainedAction |
		obtainedAction := obtainedActions at: index.
		self assert: obtainedAction class equals: actionData key.
		self assert: obtainedAction order equals: actionData value ].
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> basicReleaseStructureWithNoVersions [
	<gtExample>
	"I create a repository release for a project by manually creating and linking the necessary release objects."
	| project projectRelease repositoryRelease |
	
	project := self projectAWithNoVersion. 
	projectRelease := GtRlProjectRelease new 
		project: project.
	repositoryRelease := GtRlRepositoryRelease new
		repository: project repository.
	repositoryRelease addProjectRelease: projectRelease.
	
	self assertDefaultInitForRepositoryRelease: repositoryRelease.
	self assert: projectRelease childReleases isEmpty.
	self assert: projectRelease parentReleases isEmpty.
	self assert: projectRelease repositoryRelease equals: repositoryRelease.
	self assert: repositoryRelease projectReleases asArray equals: { projectRelease }.

	^ repositoryRelease
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> basicReleaseWithBranchStrategyOnNoVersionsRepo [
	<gtExample>
	"I create a repository release that has a branch release strategy."
	| releaseStrategy repositoryRelease |
	
	repositoryRelease := self basicReleaseStructureWithNoVersions.
	releaseStrategy := self dedicatedBranchReleaseStrategy.
	repositoryRelease releaseStrategy: releaseStrategy.	
	releaseStrategy repositoryRelease: repositoryRelease.

	self assert: releaseStrategy repositoryRelease equals: repositoryRelease.
	self assert: repositoryRelease releaseStrategy equals: releaseStrategy.
	self assert: repositoryRelease semanticVersionTags isEmpty description: 'A newly created repository should have no release tags'.
	self assert: (repositoryRelease icebergRepository hasLocalBranchNamed: releaseStrategy releaseBranchName) not. 

	^ repositoryRelease
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> basicReleaseWithLatestCommitStrategyOnNoVersionRepo [
	<gtExample>
	"I create a repository release that has a head commit release strategy."
	| releaseStrategy repositoryRelease |
	
	repositoryRelease := self basicReleaseStructureWithNoVersions.
	releaseStrategy := self headCommitReleaseStrategy.
	repositoryRelease releaseStrategy: releaseStrategy.	
	releaseStrategy repositoryRelease: repositoryRelease.

	self assert: releaseStrategy repositoryRelease equals: repositoryRelease.
	self assert: repositoryRelease releaseStrategy equals: releaseStrategy. 

	^ repositoryRelease
]

{ #category : #'examples - strategies' }
GtRlLeafRepositoryReleaseExamples >> dedicatedBranchReleaseStrategy [
	<gtExample>
	"I create a release strategy that uses a dedicated branch."
	| releaseStrategy |
	releaseStrategy := GtRlDedicatedBranchReleaseStrategy new
		nextVersionComputation: (GtRlMinorVersionComputation new
			defaultVersionNumber: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0));
		shouldForceNewRelease: false;
		referenceBranchName: 'master';
		releaseBranchName: 'release'.

	self assert: releaseStrategy repositoryRelease equals: nil.
	self assert: releaseStrategy shouldForceNewRelease not.
	self assert: releaseStrategy referenceBranchName equals: 'master'.
	self assert: releaseStrategy releaseBranchName equals: 'release'.

	^ releaseStrategy
]

{ #category : #'examples - strategies' }
GtRlLeafRepositoryReleaseExamples >> headCommitReleaseStrategy [
	<gtExample>
	"I create a release strategy that uses the head commit."
	| releaseStrategy |
	
	releaseStrategy := GtRlHeadCommitReleaseStrategy new.
	self assert: releaseStrategy description  equals: 'HeadCommit'.
	
	^ releaseStrategy
	
	
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> releaseWithBranchStrategyForcingReleaseOnOneVersionRepo [
	<gtExample>
	"I create a repository release for a repository with one version and a branch release strategy that forces a new release."
	| project releaseBuiler projectRelease repositoryRelease |
	project := self projectWithOneReleasedVersionAndNoChanges.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationForcingRelease.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	repositoryRelease := projectRelease repositoryRelease. 
	
	self assert: repositoryRelease isPassiveRelease not.
	self assert: repositoryRelease version equals: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0).
	self assert: repositoryRelease releaseActions isEmpty not.
	self assert: projectRelease releaseActions isEmpty.
	self assertReleaseActions: repositoryRelease equalTypes: { 
		GtRlMergeToReleaseBranchAction -> 1.
		GtRlExportReleaseMetadataAction -> 2.
		GtRlCommitAndTagReleaseAction -> 3 }.
	
	^ repositoryRelease
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> releaseWithBranchStrategyOnNoVersionRepo [
	<gtExample>
	"I create a reposiory release with no version that has its actions and 
	versions updated using its branch release strategy."
	| release updateWorkflow |
	release := self basicReleaseWithBranchStrategyOnNoVersionsRepo.	
	updateWorkflow := GtRlReleaseUpdateWorkflow new.
	updateWorkflow updateRepository: release.
	
	self assert: release version equals: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self assert: release isPassiveRelease not.
	self assert: release releaseActions count equals: 3.
	self assertReleaseActions: release equalTypes: { 
		GtRlMergeToReleaseBranchAction -> 1.
		GtRlExportReleaseMetadataAction -> 2.
		GtRlCommitAndTagReleaseAction -> 3 }.

	^ release
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> releaseWithBranchStrategyOnOneVersionRepo [
	<gtExample>
	"I create a repository release for a repository with one version and a branch release strategy."
	| project releaseBuiler projectRelease repositoryRelease |
	project := self projectWithOneReleasedVersionAndNoChanges.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self defaultReleaseConfiguration.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	repositoryRelease := projectRelease repositoryRelease. 
	
	self assert: repositoryRelease isPassiveRelease.
	self assert: repositoryRelease version equals: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self assert: repositoryRelease releaseActions isEmpty.
	self assert: projectRelease releaseActions isEmpty.
	
	^ repositoryRelease
]

{ #category : #'examples - releases' }
GtRlLeafRepositoryReleaseExamples >> releaseWithLatestCommitStrategyOnNoVersionRepo [
	<gtExample>
	"I create a reposiory release with no version that has its actions and 
	versions updated using its head commit release strategy."
	| release updateWorkflow |
	release := self basicReleaseWithLatestCommitStrategyOnNoVersionRepo.	
	updateWorkflow := GtRlReleaseUpdateWorkflow new.
	updateWorkflow updateRepository: release.
	
	self assert: release version equals: (GtRlCommitIdVersionNumber new
		commitId: release icebergRepository headCommit id).
	self assert: release isPassiveRelease.
	self assert: release releaseActions count equals: 0.
	
	^ release
]

{ #category : #'examples - workflows' }
GtRlLeafRepositoryReleaseExamples >> releaseWorkflowWithDedicatedBranchForInitialVersion [
	<gtExample>
	"I execute a release workflow for a release that has no previous versions and a branch release strategy."
	| release exportWorkflow |
	release := self releaseWithBranchStrategyOnNoVersionRepo.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 1.
	self assert: release semanticVersionTags first name equals: 'v0.1.0'.
	self assertExecutedActions: exportWorkflow releaseActions.

	^ exportWorkflow
]

{ #category : #'examples - workflows' }
GtRlLeafRepositoryReleaseExamples >> releaseWorkflowWithDedicatedBranchForSecondForcedVersion [
	<gtExample>
	"I execute a release workflow for a release that has one previous versions and a branch release strategy that forces a release."
	| release exportWorkflow |
	release := self releaseWithBranchStrategyForcingReleaseOnOneVersionRepo.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 2.
	self assert: release semanticVersionTags second name equals: 'v0.2.0'.
	self assertExecutedActions: exportWorkflow releaseActions.

	^ exportWorkflow
]

{ #category : #'examples - workflows' }
GtRlLeafRepositoryReleaseExamples >> releaseWorkflowWithLatestCommitForInitialVersion [
	<gtExample>
	"I execute a release workflow for a release that uses the commit as the release version."
	| release exportWorkflow |
	release := self releaseWithLatestCommitStrategyOnNoVersionRepo.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 0.
	self assert: exportWorkflow releaseActions count equals: 0.

	^ exportWorkflow
]
