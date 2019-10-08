"
I traverse a baseline model and create an equivalent release model. 

I work as follows:
	- for each ${class:GtRlProject}$ I create a ${class:GtRlProjectRelease}$
	- for each ${class:GtRlRepository}$ I create a ${class:GtRlRepositoryRelease}$
	- for each repository and project release I create child/parent relations based on the relations between projects and repositories.
	
I also use the given ${class:GtRlReleaseConfiguration}$ instance to initialize each repository release with a release strategy.

"
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
	projectRelease := GtRlProjectRelease forProject: aProject.
	repositoryRelease := self ensureRepositoryReleaseFor: aProject repository.
	repositoryRelease addProjectRelease: projectRelease.
	self createChildrenForProjectRelease: projectRelease.
	
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
GtRlReleaseStructureBuilder >> createChildrenForProjectRelease: projectRelease [.
	projectRelease project childProjects do: [ :aChildProject |
		| childProjectRelease |
		childProjectRelease := self projectReleasesMap
			at: aChildProject
			ifAbsentPut: [ self buildStructureForProject: aChildProject ].
		projectRelease addChildRelease: childProjectRelease ]
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
