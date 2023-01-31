Class {
	#name : #GtRlRepositoryActiveReleaseVersionSignal,
	#superclass : #GtRlReleaserSignal,
	#instVars : [
		'repositoryRelease',
		'version'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlRepositoryActiveReleaseVersionSignal class >> repositoryRelease: aRepositoryRelease version: aVersion [
	^ self new
	repositoryRelease: aRepositoryRelease;
	version: aVersion.
]

{ #category : #accessing }
GtRlRepositoryActiveReleaseVersionSignal >> printOneLineContentsOn: stream [
	(version versionString) printOn: stream. 
	stream nextPutAll: ' '. 
	repositoryRelease repository url printOn: stream. 
	
]

{ #category : #accessing }
GtRlRepositoryActiveReleaseVersionSignal >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlRepositoryActiveReleaseVersionSignal >> repositoryRelease: anObject [
	repositoryRelease := anObject
]

{ #category : #accessing }
GtRlRepositoryActiveReleaseVersionSignal >> version [
	^ version
]

{ #category : #accessing }
GtRlRepositoryActiveReleaseVersionSignal >> version: anObject [
	version := anObject
]
