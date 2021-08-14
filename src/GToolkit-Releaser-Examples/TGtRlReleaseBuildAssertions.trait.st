Trait {
	#name : 'TGtRlReleaseBuildAssertions',
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertReleaseActions: aRelease equalTypes: expectedActionTypesWithOrder [
	| obtainedActions |
	obtainedActions := aRelease releaseActions actions.
	self assert: obtainedActions size equals: expectedActionTypesWithOrder size.
	expectedActionTypesWithOrder withIndexDo: [ :actionData :index |
		| obtainedAction |
		obtainedAction := obtainedActions at: index.
		self assert: obtainedAction class equals: actionData key.
		self assert: obtainedAction order equals: actionData value ].
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertReleaseWithBranchStrategy: projectRelease withNewVersion: aVersion withActionsNoCompileStartingAt: firstActionsOrder pushAt: pushOrder [
	
	self assert: projectRelease releaseActions isEmpty. 
	self assert: projectRelease version equals: aVersion.
	
	self 
		assertReleaseActions: projectRelease repositoryRelease
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> firstActionsOrder.
			GtRlExportReleaseMetadataAction -> (firstActionsOrder + 1).
			GtRlCommitAndTagReleaseAction -> (firstActionsOrder + 2).
			GtRlPushToOriginReleaseAction -> pushOrder }.
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: aVersion.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertReleaseWithBranchStrategy: projectRelease withNewVersion: aVersion withActionsStartingAt: firstActionsOrder pushAt: pushOrder [
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> (firstActionsOrder + 1) }. "The compile action is the second"
	self assert: projectRelease version equals: aVersion.
	
	self 
		assertReleaseActions: projectRelease repositoryRelease
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> firstActionsOrder.
			GtRlExportReleaseMetadataAction -> (firstActionsOrder + 2).
			GtRlCommitAndTagReleaseAction -> (firstActionsOrder + 3).
			GtRlPushToOriginReleaseAction -> pushOrder }.
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: aVersion.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertReleaseWithBranchStrategy: projectRelease withNewVersion: aVersion withCompileAndNoPushActionsStartingAt: firstActionsOrder [
	
	self assertReleaseActions: projectRelease equalTypes: { 
		GtRlCompileBaselineReleaseAction -> (firstActionsOrder + 1) }. "The compile action is the second"
	self assert: projectRelease version equals: aVersion.
	
	self 
		assertReleaseActions: projectRelease repositoryRelease
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> firstActionsOrder.
			GtRlExportReleaseMetadataAction -> (firstActionsOrder + 2).
			GtRlCommitAndTagReleaseAction -> (firstActionsOrder + 3) }.
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: aVersion.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertReleaseWithBranchStrategy: projectRelease withNewVersion: aVersion withoutCompileAndNoPushActionsStartingAt: firstActionsOrder [
	
	self assert: projectRelease releaseActions isEmpty. 
	self assert: projectRelease version equals: aVersion.
	
	self 
		assertReleaseActions: projectRelease repositoryRelease
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> firstActionsOrder.
			GtRlExportReleaseMetadataAction -> (firstActionsOrder + 1).
			GtRlCommitAndTagReleaseAction -> (firstActionsOrder + 2) }.
	self 
		assertRepositoryReleaseWithBranchStrategy: projectRelease repositoryRelease 
		andNewVersion: aVersion.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertRepositoryReleaseActions: aRelease withOrders: actionsOrders [
	self assert: actionsOrders size equals: 3.
	self 
		assertReleaseActions: aRelease  
		equalTypes: { 
			GtRlMergeToReleaseBranchAction -> actionsOrders first.
			GtRlExportReleaseMetadataAction -> actionsOrders second.
			GtRlCommitAndTagReleaseAction -> actionsOrders third }.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertRepositoryReleaseWithBranchStrategy: repositoryRelease andExistingVersion: aVersion [
	self assert: repositoryRelease releaseStrategy shouldCreateNewRelease not.
	self assert: repositoryRelease isPassiveRelease.
	self assert: repositoryRelease version equals: aVersion.
	self assert: repositoryRelease releaseActions isEmpty.
]

{ #category : 'asserting' }
TGtRlReleaseBuildAssertions >> assertRepositoryReleaseWithBranchStrategy: repositoryRelease andNewVersion: aVersion [
	self assert: repositoryRelease releaseStrategy shouldCreateNewRelease.
	self assert: repositoryRelease isPassiveRelease not.
	self assert: repositoryRelease version equals: aVersion.
	self assert: repositoryRelease releaseActions isEmpty not.
]
