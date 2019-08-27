"
I export metadata associated with the current release. The metadata consists in an external file having information about dependencies and version numbers. This is performed to help tools reason about dependencies without having to load or parse the code of Metacello baselines.

See ${class:GtRlReleaseVersionMetadata}$ for more details about what metadata is associated with a release. 
"
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

{ #category : #ui }
GtRlExportReleaseMetadataAction >> gtViewPreviousVersionDiffFor: aView [
	<gtView>
	self repositoryRelease ifNil: [ ^ aView ].
	self repositoryRelease semanticVersionTags ifEmpty: [ ^ self ].
	
	^ aView textEditor
		title: 'Diff previous version' translated;
		priority: 20;
		text: [ :anEditor | 
			| latestTag  metadataCode |
			latestTag := self repositoryRelease latestSemanticVersionTag.
			metadataCode := self metadataForCommit: latestTag commit.
			GtEpiceaDiffStencil new
				from: (metadataCode ifNil: [ '' ]);
				to: (STON toJsonStringPretty: self repositoryRelease versionsMetadata);
				create ]
]

{ #category : #baselines }
GtRlExportReleaseMetadataAction >> metadataForCommit: aCommit [
	| metadataFile |
	metadataFile := aCommit fileSystem children 
		detect: [ :e | 
			e isFile and: [ 
				e basename = '.baseline-metadata.ston' ] ]
		ifNone: [ ^ nil ].
	^ metadataFile contents
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
