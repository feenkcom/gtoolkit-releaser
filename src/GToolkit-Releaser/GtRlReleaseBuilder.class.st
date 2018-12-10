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
GtRlReleaseBuilder >> configureNormalRelease: aRepositoryRelease [
	"Very ugly method. Fix later by having strategies for how to build the release."
	| releaseStrategy releaseVersion latestReleaseCommit dependencyVersions |
	releaseStrategy := GtRlDedicatedReleaseBranchStragegy new
		releaseBranchName: (self releaseBranchForRepository: aRepositoryRelease repository);
		referenceBranchName: aRepositoryRelease repository icebergRepository branchName.
	releaseVersion := self releaseVersionForRepository: aRepositoryRelease repository.
	
	"1. if there is no tag a new release is needed"
	aRepositoryRelease semanticVersionTags size = 0 ifTrue: [
		^ aRepositoryRelease
			version: releaseVersion;
			releaseStrategy: releaseStrategy ].
		
	"2. latest release tag should include the latest commit from the reference branch"
	latestReleaseCommit := aRepositoryRelease gtLatestSemanticVersionTag commit.
	(latestReleaseCommit isParentOf: releaseStrategy referenceBranch commit) ifTrue: [
		^ aRepositoryRelease
			version: releaseVersion;
			releaseStrategy: releaseStrategy ].
		
	"3. if any dependency needs to have a new version generate a new release"
	dependencyVersions := {  }.
	(aRepositoryRelease childRepositoryReleases anySatisfy: [ :aChildRelease |
		aChildRelease versionString ~= (dependencyVersions versionFor: aChildRelease) ]) ifTrue: [
			^ aRepositoryRelease
				version: releaseVersion;
				releaseStrategy: releaseStrategy ].
	
	self flag: 'Use the current tag as a version'
		
	
	
	
]

{ #category : #'private - configuration' }
GtRlReleaseBuilder >> configureRepositoryRelease: aRepositoryRelease [
	"Very ugly method. Fix later by having strategies for how to build the release."
	(self configuration shouldIgnoreProject: aRepositoryRelease repository id)
		ifTrue: [  
			aRepositoryRelease
				version: (self releaseVersionForRepository: aRepositoryRelease repository);
				releaseStrategy: GtRlNoReleaseStragegy new ]
		ifFalse: [
			"self configureNormalRelease: aRepositoryRelease"
			aRepositoryRelease
				version: (self releaseVersionForRepository: aRepositoryRelease repository);
				releaseStrategy: (GtRlDedicatedReleaseBranchStragegy new
					releaseBranchName: (self releaseBranchForRepository: aRepositoryRelease repository);
					referenceBranchName: aRepositoryRelease repository icebergRepository branchName)]
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
