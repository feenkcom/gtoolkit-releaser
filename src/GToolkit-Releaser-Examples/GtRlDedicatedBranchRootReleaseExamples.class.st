Class {
	#name : 'GtRlDedicatedBranchRootReleaseExamples',
	#superclass : 'GtRlReleaserExamples',
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : 'assertions' }
GtRlDedicatedBranchRootReleaseExamples >> assertBaselineContentForProjectRelease: projectRelease [
	self 
		assert: (projectRelease project baselineClass>>#baseline:) sourceCode 
		equals: projectRelease generateBaselineSource
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> baselineCodeReleaseForFourRepositoriesWithNewCommit [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''RepositoryWithNoVersionA'' with: [
				spec repository: ''github://example/RepositoryWithNoVersionA:v0.2.0/src'' ].
		spec
			baseline: ''RepositoryWithTagAndNoVersion'' with: [
				spec repository: ''github://example/RepositoryWithTagAndNoVersion:v0.1.0/src'' ].
		spec
			baseline: ''ProjectWithReleasedVersionAndNoChanges'' with: [
				spec repository: ''github://example/ProjectWithReleasedVersionAndNoChanges:v0.1.0/src'' ].
	]'

	
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> baselineCodeReleaseForFourRepositoriesWithNoVersionAndNoNewChanges [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''RepositoryWithNoVersionA'' with: [
				spec repository: ''github://example/RepositoryWithNoVersionA:v0.1.0/src'' ].
		spec
			baseline: ''RepositoryWithTagAndNoVersion'' with: [
				spec repository: ''github://example/RepositoryWithTagAndNoVersion:v0.1.0/src'' ].
		spec
			baseline: ''ProjectWithReleasedVersionAndNoChanges'' with: [
				spec repository: ''github://example/ProjectWithReleasedVersionAndNoChanges:v0.1.0/src'' ].
	]'

	
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> baselineCodeReleaseWithHeadCommitChildRepositoryWithId: aCommidId [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''RepositoryWithNoVersionB'' with: [
				spec repository: ''github://example/RepositoryWithNoVersionB:{1}/src'' ].
	]' format: { aCommidId }
	
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> printBaselineCodeReleaseForFourRepositoriesWithNewCommit [
	<gtExample>
	| projectRelease printer |
	projectRelease := self releaseForFourRepositoriesWithNewCommit projectReleases first.
	printer := GtRlProjectReleaseBaselinePrinter forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineCodeReleaseForFourRepositoriesWithNewCommit.
		
	^ printer
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> printBaselineCodeReleaseWithHeadCommitChildRepository [
	<gtExample>
	| projectRelease printer childRelease |
	projectRelease := self releaseWithHeadCommitChildRepository projectReleases first.
	printer := GtRlProjectReleaseBaselinePrinter forProjectRelease: projectRelease.
	
	childRelease := projectRelease childReleases first.
	self 
		assert: printer generateBaselineSource 
		equals: (self 
			baselineCodeReleaseWithHeadCommitChildRepositoryWithId: childRelease version commitId).
	
	^ printer
]

{ #category : 'examples - baseline printing' }
GtRlDedicatedBranchRootReleaseExamples >> printBaselineCodereleaseForFourRepositoriesWithNoVersionAndNoNewChanges [
	<gtExample>
	| projectRelease printer |
	projectRelease := self releaseForFourRepositoriesWithNoVersionAndNoNewChanges projectReleases first.
	printer := GtRlProjectReleaseBaselinePrinter forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineCodeReleaseForFourRepositoriesWithNoVersionAndNoNewChanges.
		
	^ printer
]

{ #category : 'examples - releases' }
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
	
	self 
		assertReleaseWithBranchStrategy: projectRelease 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0) 
		withCompileAndNoPushActionsStartingAt: 4.
	self 
		assertReleaseWithBranchStrategy:  projectRelease childReleases first 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0) 
		withoutCompileAndNoPushActionsStartingAt: 1.
	
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases second repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases third repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	
	^ projectRelease repositoryRelease
]

{ #category : 'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseForFourRepositoriesWithNoVersionAndNoNewChanges [
	<gtExample>
	"I create a repository release for a repository multiple dependencies and a branch release strategy."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithThreeDependencies.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self defaultReleaseConfiguration.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self 
		assertReleaseWithBranchStrategy: projectRelease 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0) 
		withCompileAndNoPushActionsStartingAt: 7.
	self 
		assertReleaseWithBranchStrategy: projectRelease childReleases first 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0) 
		withoutCompileAndNoPushActionsStartingAt: 1.
	self 
		assertReleaseWithBranchStrategy: projectRelease childReleases second 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0) 
		withoutCompileAndNoPushActionsStartingAt: 4.
		
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease childReleases third repositoryRelease 
		andExistingVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0).
	
	^ projectRelease repositoryRelease
]

{ #category : 'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepository [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self 
		assertReleaseWithBranchStrategy: projectRelease 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0) 
		withCompileAndNoPushActionsStartingAt: 1.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : 'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepositoryWithNewCommit [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy and has new commit."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	self releaseNewVersionForProject: project usingConfig: self releaseConfigurationWithHeadCommitStrategyForChild.
	
	"checkout ends up with MCPackageLoader>>basicLoad which may flush changes file"
	GtPharoCodeModifier current critical: [
		(project repository icebergRepository branchNamed: 'master') checkout ].

	self commiNewMethodNamed: #method1 onMasterToProject: project childProjects first.
	
	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self 
		assertReleaseWithBranchStrategy: projectRelease 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 2 patch: 0) 
		withCompileAndNoPushActionsStartingAt: 1.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : 'examples - releases' }
GtRlDedicatedBranchRootReleaseExamples >> releaseWithHeadCommitChildRepositoryWithNoChange [
	<gtExample>
	"I create a release for a repository with a dependency to a repository that uses a head commit release strategy
	when the root repository has already a release and the child repository has no new changes."
	| project releaseBuiler projectRelease |
	project := self projectStructureWithOneChildDependency.
	self releaseNewVersionForProject: project usingConfig: self releaseConfigurationWithHeadCommitStrategyForChild.
	
	GtPharoCodeModifier current critical: [
		(project repository icebergRepository branchNamed: 'master') checkout ].

	releaseBuiler := GtRlReleaseBuilder new
		configuration: self releaseConfigurationWithHeadCommitStrategyForChild.
	projectRelease := releaseBuiler buildReleaseForProject: project.
	
	self assert: projectRelease repositoryRelease isPassiveRelease.
	self assert: projectRelease childReleases first repositoryRelease isPassiveRelease.

	^ projectRelease repositoryRelease
]

{ #category : 'examples - workflows' }
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

{ #category : 'examples - workflows' }
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

{ #category : 'examples - workflows' }
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

{ #category : 'examples - workflows' }
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
