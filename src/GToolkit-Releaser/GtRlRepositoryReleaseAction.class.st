"
I model a release action executed on a repository release. I only work with release strategies of type {{gtClass:GtRlSemanticTagReleaseStrategy}} as the other strategies require no release actions.


"
Class {
	#name : 'GtRlRepositoryReleaseAction',
	#superclass : 'GtRlReleaseAction',
	#instVars : [
		'repositoryRelease'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : 'instance creation' }
GtRlRepositoryReleaseAction class >> forRepositoryRelease: aRepositoryRelease [
	^ self new
		repositoryRelease: aRepositoryRelease
]

{ #category : 'accessing' }
GtRlRepositoryReleaseAction >> releaseStrategy [
	^ self repositoryRelease releaseStrategy
]

{ #category : 'accessing' }
GtRlRepositoryReleaseAction >> repositoryRelease [
	^ repositoryRelease
]

{ #category : 'accessing' }
GtRlRepositoryReleaseAction >> repositoryRelease: aRepositoryRelease [
	self 
		assert: [ aRepositoryRelease releaseStrategy isKindOf: GtRlSemanticTagReleaseStrategy ] 
		description: 'Release actions should only work with release strategies that can perform merges, commits and tags.'.
	repositoryRelease := aRepositoryRelease
]
