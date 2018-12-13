Class {
	#name : #GtRlExportReleaseMetadataAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlExportReleaseMetadataAction >> description [
	^ self descriptionDetails
]

{ #category : #printing }
GtRlExportReleaseMetadataAction >> descriptionDetails [
	^ 'Export ', GtRlReleaseVersionMetadata fileName
]

{ #category : #ui }
GtRlExportReleaseMetadataAction >> gtBaselineVersionMetadataFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Version data' translated;
		priority: 45;
		text: [ STON toJsonStringPretty: self repositoryRelease versionsMetadata ]
]

{ #category : #printing }
GtRlExportReleaseMetadataAction >> name [
	^ 'Export release metadata'
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> performAction [
	| versionsFile fileName |
	fileName := GtRlReleaseVersionMetadata fileName.
	versionsFile := self repositoryRelease icebergRepository repositoryDirectory / fileName.	
	versionsFile 
		ensureDelete;
		writeStreamDo: [ :aStream |
			aStream nextPutAll: (STON toJsonStringPretty: self repositoryRelease versionsMetadata) ].
	
	"Manually add the versions file to the git index to be included in the next commit."
	self repositoryRelease icebergRepository addFileToIndex: fileName asFileReference.
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> repositoriesDependenciesByVersion [
	^ (self repositoryRelease childRepositoryReleases collect: [ :aRepositoryRelease |
		aRepositoryRelease repository id -> aRepositoryRelease versionString ]) asDictionary.
]
