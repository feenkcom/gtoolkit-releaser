Class {
	#name : #GtRlReleaseBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlReleaseBuilder class >> forConfiguration: aReleaseConfiguration [
	^ self new
		configuration: aReleaseConfiguration
]

{ #category : #building }
GtRlReleaseBuilder >> buildReleaseForProject: aProject [
	| projectRelease |
	projectRelease := self structureBuilder buildStructureForProject: aProject.
	(self repositoriesInReleaseOrderFor: projectRelease) do: [ :aRepositoryRelease | 
		self configureRepositoryRelease: aRepositoryRelease ].
	^ projectRelease 
]

{ #category : #accessing }
GtRlReleaseBuilder >> configuration [
	^ configuration
]

{ #category : #accessing }
GtRlReleaseBuilder >> configuration: aReleaseConfiguration [
	configuration := aReleaseConfiguration
]

{ #category : #'private - configuration' }
GtRlReleaseBuilder >> configureBranchStrategyForRelease: aRepositoryRelease [
	| releaseStrategy releaseVersion |
	releaseStrategy := GtRlDedicatedReleaseBranchStragegy new
		releaseBranchName: (self releaseBranchForRepository: aRepositoryRelease repository);
		referenceBranchName: aRepositoryRelease repository icebergRepository branchName.
	releaseVersion := self releaseVersionForRepository: aRepositoryRelease repository.
	aRepositoryRelease
		version: releaseVersion;
		releaseStrategy: releaseStrategy
]

{ #category : #'private - configuration' }
GtRlReleaseBuilder >> configureNullReleaseStrategyForRelease: aRepositoryRelease [ 
	^ aRepositoryRelease
		version: (self releaseVersionForRepository: aRepositoryRelease repository);
		releaseStrategy: GtRlNullReleaseBuildStragegy new
]

{ #category : #'private - configuration' }
GtRlReleaseBuilder >> configureReleaseStrategyRelease: aRepositoryRelease [
	| latestVersionTag latestRefenceBranchCommit releaseMetadata |

	"1. If there is no release tag in the repository a new release is needed."
	aRepositoryRelease semanticVersionTags isEmpty ifTrue: [
		^ self configureBranchStrategyForRelease: aRepositoryRelease ].
	
	"2. The latest release tag should include the latest commit from the reference branch."
	latestVersionTag := aRepositoryRelease latestSemanticVersionTag.
	latestRefenceBranchCommit := aRepositoryRelease icebergRepository branch commit.
	(latestVersionTag commit isParentOf: latestRefenceBranchCommit) ifFalse: [
		^ self configureBranchStrategyForRelease: aRepositoryRelease ].
	
	"3. If any dependency has a different version than in the current release generate a new release"
	releaseMetadata := GtRlReleaseVersionMetadata fromCommit: latestVersionTag commit.
	(aRepositoryRelease matchesDependenciesIn: releaseMetadata) ifTrue: [
		^ self configureBranchStrategyForRelease: aRepositoryRelease ].
	
	^ aRepositoryRelease
		version: latestVersionTag gtAsSemanticVersionNumber;
		releaseStrategy: GtRlNullReleaseBuildStragegy new
]

{ #category : #'private - configuration' }
GtRlReleaseBuilder >> configureRepositoryRelease: aRepositoryRelease [
	"Less then ideal solution. Could be improved by having strategies for how to build the release."
	(self configuration shouldIgnoreProject: aRepositoryRelease repository id)
		ifTrue: [ self configureNullReleaseStrategyForRelease: aRepositoryRelease ]
		ifFalse: [ 
			self configuration shouldForceNewRelease 
				ifTrue: [ self configureBranchStrategyForRelease: aRepositoryRelease ]
				ifFalse: [ self configureReleaseStrategyRelease: aRepositoryRelease ] ]
]

{ #category : #'private - building' }
GtRlReleaseBuilder >> releaseBranchForRepository: aRepository [
	^ self configuration releaseBranchForRepository: aRepository
]

{ #category : #'private - building' }
GtRlReleaseBuilder >> releaseVersionForRepository: aRepository [
	^ self configuration releaseVersionForRepository: aRepository
	
]

{ #category : #'accessing - dynamic' }
GtRlReleaseBuilder >> repositoriesInReleaseOrderFor: aProjectRelease [
	^ (aProjectRelease repositoryRelease withDeepCollect: #childRepositoryReleases) reversed
]

{ #category : #'accessing - dynamic' }
GtRlReleaseBuilder >> structureBuilder [
	^ GtRlReleaseStructureBuilder new
]
