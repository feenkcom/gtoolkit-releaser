"
I contain information about a concrete release within a repository. 

Currently I contain the list of direct dependencies for all baselines contained in a repository. I store this list in a JSON file within the repository. It is the responsability of the user to update this meta-data every time the baseline is changed. During the release process this is ensured using the action {{gtClass:GtRlExportReleaseMetadataAction}}.

By default the baseline of a version contains all dependency information needed to load that version. However, that information is stored in the method `'baseline:'` within the baseline class. Accessing it requires loading or parsing the code of the baseline. Having the dependency list stored in an external JSON file make it easier for tools to access dependencie without havign to deal with the actual code. The meta-data file could in the future contain other types of information, not just the list of dependencies.


"
Class {
	#name : #GtRlReleaseVersionMetadata,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlReleaseVersionMetadata class >> fileName [ 
	^ '.baseline-metadata.ston'
]

{ #category : #'instance creation' }
GtRlReleaseVersionMetadata class >> fromCommit: anIceCommmit [

	^ self new data: (STON fromString: (self metadataFileFroCommit: anIceCommmit) contents)
]

{ #category : #'instance creation' }
GtRlReleaseVersionMetadata class >> metadataFileFroCommit: anIceCommmit [

	^ anIceCommmit fileSystem / self fileName
]

{ #category : #converting }
GtRlReleaseVersionMetadata >> asJSONForExport [
	^ STON toJsonStringPretty: data
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> data [
	^ data
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> data: aDictionary [
	data := aDictionary
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> fileName [
	^ self class fileName
]

{ #category : #ui }
GtRlReleaseVersionMetadata >> gtBaselineVersionMetadataFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Version data' translated;
		priority: 20;
		text: [ self asJSONForExport ]
]

{ #category : #ui }
GtRlReleaseVersionMetadata >> gtRepositoryVersionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories' translated;
		items: [ self repositoryData associations ];
		column: 'Repository' text: [ :assoc | assoc key ];
		column: 'Version' text: [ :assoc | assoc value ]
]

{ #category : #testing }
GtRlReleaseVersionMetadata >> hasVersionForRelease: aRepositoryRelease [
	^ self repositoryData includesKey: aRepositoryRelease repository id
]

{ #category : #initialization }
GtRlReleaseVersionMetadata >> initialize [
	super initialize.
	
	data := Dictionary new
]

{ #category : #testing }
GtRlReleaseVersionMetadata >> matchesVersionForRelease: aRelease [
	^ (self hasVersionForRelease: aRelease) and: [ 
		aRelease versionString = (self versionForRelease: aRelease) ]
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> repositories: aCollectionOfRepositoriesWithVersions [
	data at: 'repositories' put: aCollectionOfRepositoriesWithVersions
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> repositoryData [
	^ self data at: 'repositories' ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseVersionMetadata >> versionForRelease: aRepositoryRelease [
	^ self repositoryData at: aRepositoryRelease repository id
]
