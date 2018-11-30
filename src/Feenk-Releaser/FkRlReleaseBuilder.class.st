Class {
	#name : #FkRlReleaseBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'projectReleasesMap',
		'repositoryReleasesMap'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
FkRlReleaseBuilder class >> forConfiguration: aReleaseConfiguration [
	^ self new
		configuration: aReleaseConfiguration
]

{ #category : #building }
FkRlReleaseBuilder >> buildReleaseForPoject: aProject [
	| projectRelease repositoryRelease |
	projectRelease := FkRlProjectRelease new project: aProject.
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
FkRlReleaseBuilder >> configuration [
	^ configuration
]

{ #category : #accessing }
FkRlReleaseBuilder >> configuration: aReleaseConfiguration [
	configuration := aReleaseConfiguration
]

{ #category : #'private - building' }
FkRlReleaseBuilder >> ensureRepositoryReleaseFor: aRepository [
	^ self repositoryReleasesMap at: aRepository ifAbsentPut: [ 
		FkRlRepositoryRelease new
			repository: aRepository;
			version: (self releaseVersionForRepository: aRepository);
			releaseStrategy: (self releaseStragegyForRepository: aRepository) ]
]

{ #category : #accessing }
FkRlReleaseBuilder >> projectReleasesMap [
	^ projectReleasesMap ifNil: [ 
		projectReleasesMap := Dictionary new ]
]

{ #category : #'private - building' }
FkRlReleaseBuilder >> releaseBranchForRepository: aRepository [
	^ self configuration releaseBranchForRepository: aRepository
]

{ #category : #'private - building' }
FkRlReleaseBuilder >> releaseStragegyForRepository: aRepository [
	^ (self configuration shouldIgnoreProject: aRepository id)
		ifTrue: [ FkRlNoReleaseStragegy new ]
		ifFalse: [ FkRlDedicatedReleaseBranchStragegy new
			releaseBranchName: (self releaseBranchForRepository: aRepository);
			referenceBranchName: aRepository icebergRepository branchName ]
]

{ #category : #'private - building' }
FkRlReleaseBuilder >> releaseVersionForRepository: aRepository [
	^ self configuration releaseVersionForRepository: aRepository
	
]

{ #category : #accessing }
FkRlReleaseBuilder >> repositoryReleasesMap [
	^ repositoryReleasesMap ifNil: [ 
		repositoryReleasesMap := Dictionary new ]
]
