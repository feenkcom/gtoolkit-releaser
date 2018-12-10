Class {
	#name : #GtRlReleaseStructureBuilder,
	#superclass : #Object,
	#instVars : [
		'projectReleasesMap',
		'repositoryReleasesMap'
	],
	#category : #'GToolkit-Releaser'
}

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
	^ projectRelease
]

{ #category : #'private - building' }
GtRlReleaseStructureBuilder >> ensureRepositoryReleaseFor: aRepository [
	^ self repositoryReleasesMap at: aRepository ifAbsentPut: [ 
		GtRlRepositoryRelease forRepository: aRepository ]
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
