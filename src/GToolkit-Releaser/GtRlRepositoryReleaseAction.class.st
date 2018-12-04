Class {
	#name : #GtRlRepositoryReleaseAction,
	#superclass : #GtRlReleaseAction,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlRepositoryReleaseAction class >> forRepositoryRelease: aRepositoryRelease [
	^ self new
		repositoryRelease: aRepositoryRelease
]

{ #category : #accessing }
GtRlRepositoryReleaseAction >> releaseStrategy [
	^ self repositoryRelease releaseStrategy
]

{ #category : #accessing }
GtRlRepositoryReleaseAction >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlRepositoryReleaseAction >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]
