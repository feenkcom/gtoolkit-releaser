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
	aRepositoryRelease
		version: (self releaseVersionForRepository: aRepositoryRelease repository);
		releaseStrategy: (self releaseStragegyForRepository: aRepositoryRelease repository)
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
			self configureNormalRelease: aRepositoryRelease ]
]

{ #category : #'private - building' }
GtRlReleaseBuilder >> releaseBranchForRepository: aRepository [
	^ self configuration releaseBranchForRepository: aRepository
]

{ #category : #'private - building' }
GtRlReleaseBuilder >> releaseStragegyForRepository: aRepository [
	^ (self configuration shouldIgnoreProject: aRepository id)
		ifTrue: [ GtRlNoReleaseStragegy new ]
		ifFalse: [ GtRlDedicatedReleaseBranchStragegy new
			releaseBranchName: (self releaseBranchForRepository: aRepository);
			referenceBranchName: aRepository icebergRepository branchName ]
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
