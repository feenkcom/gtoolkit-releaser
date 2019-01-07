Class {
	#name : #GtRlRepositoryReleaseVersionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'repositoryRelease',
		'version'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlRepositoryReleaseVersionSignal class >> repositoryRelease: aRepositoryRelease version: aVersion [
	^ self new
	repositoryRelease: aRepositoryRelease;
	version: aVersion.
]

{ #category : #accessing }
GtRlRepositoryReleaseVersionSignal >> printOneLineContentsOn: stream [
	repositoryRelease printOn: stream. 
	stream nextPutAll: ' '. 
	version printOn: stream. 
]

{ #category : #accessing }
GtRlRepositoryReleaseVersionSignal >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlRepositoryReleaseVersionSignal >> repositoryRelease: anObject [
	repositoryRelease := anObject
]

{ #category : #accessing }
GtRlRepositoryReleaseVersionSignal >> version [
	^ version
]

{ #category : #accessing }
GtRlRepositoryReleaseVersionSignal >> version: anObject [
	version := anObject
]
