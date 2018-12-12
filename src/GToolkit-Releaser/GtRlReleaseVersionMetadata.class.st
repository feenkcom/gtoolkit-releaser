Class {
	#name : #GtRlReleaseVersionMetadata,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlReleaseVersionMetadata class >> fileName [ 
	^ '.baseline-versions.ston'
]

{ #category : #'instance creation' }
GtRlReleaseVersionMetadata class >> fromCommit: anIceCommmit [
	^ self new
		data: (STON fromString: (anIceCommmit fileSystem / self fileName) contents)
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> data [
	^ data
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> data: aDictionary [
	data := aDictionary
]

{ #category : #testing }
GtRlReleaseVersionMetadata >> hasVersionForRelease: aRepositoryRelease [
	^ self repositoryData includesKey: aRepositoryRelease repository id
]

{ #category : #testing }
GtRlReleaseVersionMetadata >> matchesVersionForRelease: aRelease [
	^ (self hasVersionForRelease: aRelease) and: [ 
		aRelease versionString = (self versionForRelease: aRelease) ]
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> repositoryData [
	^ self data at: 'repositories' ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> versionForRelease: aRepositoryRelease [
	^ self repositoryData at: aRepositoryRelease repository id
]
