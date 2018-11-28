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

{ #category : #accessing }
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

{ #category : #accessing }
FkRlReleaseBuilder >> ensureRepositoryReleaseFor: aRepository [
	^ self repositoryReleasesMap at: aRepository ifAbsentPut: [ 
		FkRlRepositoryRelease new
			repository: aRepository;
			branchName: self configuration defaultReleaseBranchName;
			version: (FkRlSemanticVersion new
				major: 1;
				minor: 2;
				patch: 3) ]
]

{ #category : #accessing }
FkRlReleaseBuilder >> projectReleasesMap [
	^ projectReleasesMap ifNil: [ 
		projectReleasesMap := Dictionary new ]
]

{ #category : #accessing }
FkRlReleaseBuilder >> repositoryReleasesMap [
	^ repositoryReleasesMap ifNil: [ 
		repositoryReleasesMap := Dictionary new ]
]
