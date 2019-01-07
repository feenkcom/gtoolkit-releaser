Class {
	#name : #GtRlReleaseStructureBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'projectReleasesMap',
		'repositoryReleasesMap'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlReleaseStructureBuilder class >> forConfiguration: aReleaseConfiguration [
	^ self new
		configuration: aReleaseConfiguration
]

{ #category : #building }
GtRlReleaseStructureBuilder >> buildStructureForProject: aProject [
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new project: aProject.
	repositoryRelease := self ensureRepositoryReleaseFor: aProject repository.
	repositoryRelease addProjectRelease: projectRelease.
	aProject childProjects do: [ :aChildProject |
		| childProjectRelease |
		childProjectRelease := self projectReleasesMap
			at: aChildProject
			ifAbsentPut: [ self buildStructureForProject: aChildProject ].
		projectRelease addChildRelease: childProjectRelease ].
	(GtRlProjectReleaseStructureSignal projectRelease: projectRelease repositoryRelease: repositoryRelease) emit.
	^ projectRelease
]

{ #category : #accessing }
GtRlReleaseStructureBuilder >> configuration [
	^ configuration
]

{ #category : #accessing }
GtRlReleaseStructureBuilder >> configuration: aReleaseConfiguration [
	configuration := aReleaseConfiguration
]

{ #category : #'private - building' }
GtRlReleaseStructureBuilder >> ensureRepositoryReleaseFor: aRepository [
	^ self repositoryReleasesMap at: aRepository ifAbsentPut: [ 
		| repositoryRelease releaseStrategy |
		repositoryRelease := GtRlRepositoryRelease forRepository: aRepository.
		releaseStrategy := self configuration releaseStrategyForRepository: repositoryRelease repository.
		releaseStrategy
			initializeFor: repositoryRelease 
			fromConfiguration: self configuration.
		repositoryRelease ]
]

{ #category : #accessing }
GtRlReleaseStructureBuilder >> projectReleasesMap [
	^ projectReleasesMap ifNil: [ 
		projectReleasesMap := Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseStructureBuilder >> repositoryReleasesMap [
	^ repositoryReleasesMap ifNil: [ 
		repositoryReleasesMap := Dictionary new ]
]
