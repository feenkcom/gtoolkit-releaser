Class {
	#name : #GtRlReleaseBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'projectReleasesMap',
		'repositoryReleasesMap'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
GtRlReleaseBuilder class >> forConfiguration: aReleaseConfiguration [
	^ self new
		configuration: aReleaseConfiguration
]

{ #category : #building }
GtRlReleaseBuilder >> buildReleaseForPoject: aProject [
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new project: aProject.
	repositoryRelease := self ensureRepositoryReleaseFor: aProject repository.
	repositoryRelease addProjectRelease: projectRelease.
	aProject childProjects do: [ :aChildProject |
		| childProjectRelease |
		childProjectRelease := self projectReleasesMap
			at: aChildProject
			ifAbsentPut: [ self buildReleaseForPoject: aChildProject ].
		projectRelease addChildRelease: childProjectRelease ].
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

{ #category : #'private - building' }
GtRlReleaseBuilder >> ensureRepositoryReleaseFor: aRepository [
	^ self repositoryReleasesMap at: aRepository ifAbsentPut: [ 
		GtRlRepositoryRelease new
			repository: aRepository;
			version: (self releaseVersionForRepository: aRepository);
			releaseStrategy: (self releaseStragegyForRepository: aRepository) ]
]

{ #category : #accessing }
GtRlReleaseBuilder >> projectReleasesMap [
	^ projectReleasesMap ifNil: [ 
		projectReleasesMap := Dictionary new ]
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

{ #category : #accessing }
GtRlReleaseBuilder >> repositoryReleasesMap [
	^ repositoryReleasesMap ifNil: [ 
		repositoryReleasesMap := Dictionary new ]
]
