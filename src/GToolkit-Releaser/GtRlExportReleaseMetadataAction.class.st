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
	^ 'Export for each repository the version that is loaded in the current version'
]

{ #category : #ui }
GtRlExportReleaseMetadataAction >> gtBaselineVersionMetadataFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Version data' translated;
		priority: 45;
		text: [ self repositoryRelease versionsMetadata ]
]

{ #category : #printing }
GtRlExportReleaseMetadataAction >> name [
	^ 'Export release metadata'
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> performAction [
	(self repositoryRelease repositoryDirectory / '.baseline-versions.ston') writeStreamDo: [ :aStream |
		aStream nextPutAll: self repositoryRelease versionsMetadata ]
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> repositoriesDependenciesByVersion [
	^ (self repositoryRelease childRepositoryReleases collect: [ :aRepositoryRelease |
		aRepositoryRelease repository id -> aRepositoryRelease versionString ]) asDictionary.
]
