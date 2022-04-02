Class {
	#name : #GtRlProjectReleaseStructureSignal,
	#superclass : #GtReleaserSignal,
	#instVars : [
		'projectRelease',
		'repositoryRelease'
	],
	#category : 'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlProjectReleaseStructureSignal class >> projectRelease: aProjectRelease repositoryRelease: aRepositoryRelease [
	^ self new
		projectRelease: aProjectRelease;
		repositoryRelease: aRepositoryRelease.
]

{ #category : #printing }
GtRlProjectReleaseStructureSignal >> printOneLineContentsOn: stream [
	projectRelease printOn: stream. 
	stream nextPutAll: ' -> '. 
	repositoryRelease printOn: stream. 
]

{ #category : #accessing }
GtRlProjectReleaseStructureSignal >> projectRelease [
	^ projectRelease
]

{ #category : #accessing }
GtRlProjectReleaseStructureSignal >> projectRelease: aGtRlProjectRelease [ 
	projectRelease := aGtRlProjectRelease
]

{ #category : #accessing }
GtRlProjectReleaseStructureSignal >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlProjectReleaseStructureSignal >> repositoryRelease: anObject [
	repositoryRelease := anObject
]
