"
I export metadata associated with the current release. The metadata consists in an external file having information about dependencies and version numbers. This is performed to help tools reason about dependencies without having to load or parse the code of Metacello baselines.

See {{gtClass:GtRlReleaseVersionMetadata}} for more details about what metadata is associated with a release. 


"
Class {
	#name : #GtRlExportReleaseMetadataAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : 'GToolkit-Releaser'
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
	
	^ aView forward
		title: 'Version data' translated;
		priority: 20;
		object: [
			GtRlReleaseVersionMetadata new
				repositories: self repositoryRelease versionsMetadata ];
		view: #gtBaselineVersionMetadataFor:
]

{ #category : #ui }
GtRlExportReleaseMetadataAction >> gtViewPreviousMetadataDiffFor: aView [
	<gtView>
	self repositoryRelease ifNil: [ ^ aView ].
	self repositoryRelease semanticVersionTags ifEmpty: [ ^ self ].
	
	^ aView explicit
		title: 'Diff previous metadata' translated;
		priority: 45;
		stencil: [ :anEditor | 
			| latestTag previousMetadataJson releaseMetadata |
			latestTag := self repositoryRelease latestSemanticVersionTag.
			
			previousMetadataJson := self metadataForCommit: latestTag commit.
			releaseMetadata := GtRlReleaseVersionMetadata new
				repositories: self repositoryRelease versionsMetadata.
			
			(GtDiffElement on: (TextDiffBuilder 
				from: (previousMetadataJson ifNil: [ '' ])
				to: releaseMetadata asJSONForExport)) aptitude: GtDiffShadowAptitude ]
]

{ #category : #baselines }
GtRlExportReleaseMetadataAction >> metadataForCommit: aCommit [
	| metadataFile |
	metadataFile := aCommit fileSystem children 
		detect: [ :e | e isFile and: [ 
			e basename = GtRlReleaseVersionMetadata fileName ] ]
		ifNone: [ ^ nil ].
	^ metadataFile contents
]

{ #category : #printing }
GtRlExportReleaseMetadataAction >> name [
	^ 'Export release metadata'
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> performAction [
	| versionsFile metadata |
	
	metadata := GtRlReleaseVersionMetadata new
		repositories: self repositoryRelease versionsMetadata.

	versionsFile := self repositoryRelease icebergRepository repositoryDirectory / metadata fileName.	
	versionsFile 
		ensureDelete;
		writeStreamDo: [ :aStream | aStream nextPutAll: metadata asJSONForExport ].
	
	"Manually add the versions file to the git index to be included in the next commit."
	self repositoryRelease icebergRepository addFileToIndex: metadata fileName asFileReference.
]

{ #category : #actions }
GtRlExportReleaseMetadataAction >> repositoriesDependenciesByVersion [
	^ (self repositoryRelease childRepositoryReleases collect: [ :aRepositoryRelease |
		aRepositoryRelease repository id -> aRepositoryRelease versionString ]) asDictionary.
]
