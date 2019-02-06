Class {
	#name : #GtRlDedicatedBranchRootReleaseExamples,
	#superclass : #GtRlReleaserExamples,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
GtRlDedicatedBranchRootReleaseExamples >> assertBaselineContentForProjectRelease: projectRelease [
	self 
		assert: (projectRelease project baselineClass>>#baseline:) sourceCode 
		equals: projectRelease generateBaselineSource
]

{ #category : #assertions }
GtRlDedicatedBranchRootReleaseExamples >> assertRepositoryReleaseActions: aRelease  withOrders: actionsOrders [
	self assert: actionsOrders size equals: 3.
	self 
		assertReleaseActions: aRelease  
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> actionsOrders first.
			GtRlExportReleaseMetadataAction -> actionsOrders second.
			GtRlCommitAndTagReleaseAction -> actionsOrders third}.
]

{ #category : #'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseForFourRepositoriesWithNewCommit [
	<gtExample>
	"I create a release for a repository having a released version and a dependency that has a new commit.
	Performing a new release should generate a new version only for the root repository and for the dependency
	that has the new commit."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithThreeDependencies.
	self releaseNewVersionForProject: project.
	self switchAllToMasterForProject: project.
	self commiNewMethodNamed: #method1 onMasterToProject: project childProjects first.
	
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self defaultReleaseConfiguration.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> 5 }.
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease repositoryRelease 
		withOrders: {4. 6. 7}.
	
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases first repositoryRelease
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease childReleases first repositoryRelease  
		withOrders: {1. 2. 3}.
	
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases second repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases third repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	
	^ projectRelease repositoryRelease
]

{ #category : #'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseForFourRepositoriesWithNoVersionAndNoNewChanges [
	<gtExample>
	"I create a repository release for a repository multiple dependencies and a branch release strategy."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithThreeDependencies.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self defaultReleaseConfiguration.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> 8 }.
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease repositoryRelease 
		withOrders: {7. 9. 10}.
	
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases first repositoryRelease
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease childReleases first repositoryRelease  
		withOrders: {1. 2. 3}.
	
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases second repositoryRelease
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease childReleases second repositoryRelease  
		withOrders: {4. 5. 6}.
		
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases third repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	
	^ projectRelease repositoryRelease
]

{ #category : #'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepository [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> 2 }.
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease repositoryRelease 
		withOrders: {1. 3. 4}.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : #'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepositoryWithNewCommit [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy and has new commit."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	self releaseNewVersionForProject: project usingConfig: self releaseConfigurationWithHeadCommitStrategyForChild.
	(project repository icebergRepository branchNamed: 'master') checkout.
	self commiNewMethodNamed: #method1 onMasterToProject: project childProjects first.
	
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> 2 }.
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease repositoryRelease 
		withOrders: {1. 3. 4}.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : #'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepositoryWithNoChange [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy
	when the root repository has already a release and the child repository has no new changes."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	self releaseNewVersionForProject: project usingConfig: self releaseConfigurationWithHeadCommitStrategyForChild.
	(project repository icebergRepository branchNamed: 'master') checkout.
	
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assert: projectRelease repositoryRelease isPassiveRelease.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : #'examples - workflows' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWorkflowForHeadCommitChild [
	<gtExample>
	| release exportWorkflow |
	release := self releaseWithHeadCommitChildRepository.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 1.
	self assert: release semanticVersionTags first name equals: 'v0.1.0'.
	self 
		assertNewReleaseTagOnReleaseBranchFor: release icebergRepository
		named: 'v0.1.0'.
	
	self assert: release childRepositoryReleases first semanticVersionTags size equals: 0.
	self assertExecutedActions: exportWorkflow releaseActions.
	self assertBaselineContentForProjectRelease: release projectReleases first.
	
	^ exportWorkflow
]

{ #category : #'examples - workflows' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWorkflowForHeadCommitChildWithNewCommit [
	<gtExample>
	| release exportWorkflow |
	release := self releaseWithHeadCommitChildRepositoryWithNewCommit.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 2.
	self assert: release semanticVersionTags second name equals: 'v0.2.0'.
	self 
		assertNewReleaseTagOnReleaseBranchFor: release icebergRepository
		named: 'v0.2.0'.
	
	self assert: release childRepositoryReleases first semanticVersionTags size equals: 0.
	self assertExecutedActions: exportWorkflow releaseActions.
	self assertBaselineContentForProjectRelease: release projectReleases first.
	
	^ exportWorkflow
]

{ #category : #'examples - workflows' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWorkflowForInitialVersionInMultipleRepositories [
	<gtExample>
	| release exportWorkflow |
	release := self releaseForFourRepositoriesWithNoVersionAndNoNewChanges.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 1.
	self assert: release semanticVersionTags first name equals: 'v0.1.0'.
	self 
		assertNewReleaseTagOnReleaseBranchFor: release icebergRepository
		named: 'v0.1.0'.
	release childRepositoryReleases do: [ :aRepositoryRelease |
		self 
			assertNewReleaseTagOnReleaseBranchFor: aRepositoryRelease icebergRepository
			named: 'v0.1.0' ].
	self assertExecutedActions: exportWorkflow releaseActions.
	self assertBaselineContentForProjectRelease: release projectReleases first.
	
	^ exportWorkflow
]

{ #category : #'examples - workflows' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWorkflowForMultipleRepositoriesWithNewCommit [
	<gtExample>
	| release exportWorkflow |
	release := self releaseForFourRepositoriesWithNewCommit.	
	exportWorkflow := GtRlReleaserExportWorkflow new
		rootProjectRelease: release projectReleases first.
	exportWorkflow executeReleaseActions.
	
	self assert: release semanticVersionTags size equals: 2.
	self assert: release semanticVersionTags second name equals: 'v0.2.0'.
	self 
		assertNewReleaseTagOnReleaseBranchFor: release icebergRepository
		named: 'v0.2.0'.
	self 
		assertNewReleaseTagOnReleaseBranchFor: release childRepositoryReleases first icebergRepository
		named: 'v0.2.0'.
	
	release childRepositoryReleases copyWithoutFirst do: [ :aRepositoryRelease |
		self assert: aRepositoryRelease semanticVersionTags size equals: 1.
		self assert: aRepositoryRelease semanticVersionTags first name equals: 'v0.1.0' ].
	self assertExecutedActions: exportWorkflow releaseActions.
	self assertBaselineContentForProjectRelease: release projectReleases first.
	
	^ exportWorkflow
]
