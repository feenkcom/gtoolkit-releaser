Class {
	#name : #GtRlRepositoryPassiveReleaseVersionSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'repositoryRelease',
		'version'
	],
	#category : #'GToolkit-Releaser-Logging'
}

{ #category : #'as yet unclassified' }
GtRlRepositoryPassiveReleaseVersionSignal class >> repositoryRelease: aRepositoryRelease version: aVersion [
	^ self new
	repositoryRelease: aRepositoryRelease;
	version: aVersion.
]

{ #category : #accessing }
GtRlRepositoryPassiveReleaseVersionSignal >> printOneLineContentsOn: stream [
	repositoryRelease printOn: stream. 
	stream nextPutAll: ' '. 
	version printOn: stream. 
]

{ #category : #accessing }
GtRlRepositoryPassiveReleaseVersionSignal >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlRepositoryPassiveReleaseVersionSignal >> repositoryRelease: anObject [
	repositoryRelease := anObject
]

{ #category : #accessing }
GtRlRepositoryPassiveReleaseVersionSignal >> version [
	^ version
]

{ #category : #accessing }
GtRlRepositoryPassiveReleaseVersionSignal >> version: anObject [
	version := anObject
]
