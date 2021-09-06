"
I export the version of the releaser used to create a release of the glamorous toolkit. The action should only be added as an action to the gtoolkit repository.
"
Class {
	#name : 'GtRlExportReleaserVersionAction',
	#superclass : 'GtRlRepositoryReleaseAction',
	#category : 'GToolkit-Releaser'
}

{ #category : 'printing' }
GtRlExportReleaserVersionAction >> description [
	^ self descriptionDetails
]

{ #category : 'printing' }
GtRlExportReleaserVersionAction >> descriptionDetails [
	^ self name
]

{ #category : 'printing' }
GtRlExportReleaserVersionAction >> name [ 
	^ 'Export releaser version' 
]

{ #category : 'actions' }
GtRlExportReleaserVersionAction >> performAction [	
	self repositoryRelease repositoryName = 'gtoolkit'
		ifFalse: [ ^ self ].
	
	self
		releaserVersionDo: [ :aReleaserVersion |
			| fileName versionsFile |
			
			fileName := 'gtoolkit-releaser.version'.
	
			versionsFile := self repositoryRelease icebergRepository repositoryDirectory / fileName.	
			versionsFile 
				ensureDelete;
				writeStreamDo: [ :aStream | aStream nextPutAll: aReleaserVersion versionString ].

			"Manually add the versions file to the git index to be included in the next commit."
			self repositoryRelease icebergRepository addFileToIndex: fileName asFileReference ]
		ifNone: [ ^ self ]
]

{ #category : 'accessing' }
GtRlExportReleaserVersionAction >> releaserVersionDo: ifFoundBlock ifNone: ifNoneBlock [
	^ self repositoryRelease withAllChildRepositoryReleases
		detect: [ :eachRelease | eachRelease repositoryName = 'gtoolkit-releaser' ]
		ifFound: [ :aReleaserRelease | ifFoundBlock value: aReleaserRelease version ]
		ifNone: ifNoneBlock
]
