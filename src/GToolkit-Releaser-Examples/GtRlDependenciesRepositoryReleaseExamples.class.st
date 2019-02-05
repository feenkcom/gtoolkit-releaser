Class {
	#name : #GtRlDependenciesRepositoryReleaseExamples,
	#superclass : #GtRlReleaserExamples,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
GtRlDependenciesRepositoryReleaseExamples >> assertBaselineContentForProjectRelease: projectRelease [
	self 
		assert: (projectRelease project baselineClass>>#baseline:) sourceCode 
		equals: projectRelease generateBaselineSource
]

{ #category : #assertions }
GtRlDependenciesRepositoryReleaseExamples >> assertRepositoryReleaseActions: aRelease  withOrders: actionsOrders [
	self assert: actionsOrders size equals: 3.
	self 
		assertReleaseActions: aRelease  
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> actionsOrders first.
			GtRlExportReleaseMetadataAction -> actionsOrders second.
			GtRlCommitAndTagReleaseAction -> actionsOrders third}.
]

{ #category : #'examples - releases' }
GtRlDependenciesRepositoryReleaseExamples >> releaseWithBranchStrategyForRepositoriesWithNoVersionAndNoNewChanges [
	<gtExample>
	"I create a repository release for a repository multiple dependencies and a branch release strategy."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithFourDependencies.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self defaultReleaseConfiguration.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> 11 }.
	self
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease repositoryRelease 
		withOrders: {10. 12. 13}.
	
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
		andNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseActions: projectRelease childReleases third repositoryRelease  
		withOrders: {7. 8. 9}.
		
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases fourth repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	
	^ projectRelease repositoryRelease
]

{ #category : #'examples - workflows' }
GtRlDependenciesRepositoryReleaseExamples >> releaseWorkflowWithDedicatedBranchForInitialVersionInMultipleRepositories [
	<gtExample>
	<noTest> "This does not work at the moment as the metacello toolbox wants configurations to be loaded in the image."
	| release exportWorkflow |
	release := self releaseWithBranchStrategyForRepositoriesWithNoVersionAndNoNewChanges.	
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
