Class {
	#name : #FkRlRepositoryReleaseAction,
	#superclass : #FkRlReleaseAction,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
FkRlRepositoryReleaseAction class >> forRepositoryRelease: aRepositoryRelease [
	^ self new
		repositoryRelease: aRepositoryRelease
]

{ #category : #accessing }
FkRlRepositoryReleaseAction >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
FkRlRepositoryReleaseAction >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]
