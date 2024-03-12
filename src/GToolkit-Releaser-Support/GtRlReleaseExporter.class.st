Class {
	#name : #GtRlReleaseExporter,
	#superclass : #Object,
	#instVars : [
		'releaseConfiguration',
		'repositoryMetacelloUrl',
		'baselineClass'
	],
	#category : #'GToolkit-Releaser-Support'
}

{ #category : #accessing }
GtRlReleaseExporter >> baselineClass [
	<return: #'BaselineOf class'>
	self
		assert: [ baselineClass isNotNil ]
		description: [ 'Baseline class must be non-nil' ].
	^ baselineClass
]

{ #category : #'api - initialization' }
GtRlReleaseExporter >> baselineClass: anObject [
	baselineClass := anObject
]

{ #category : #'api - building' }
GtRlReleaseExporter >> buildReleaseWorkflow [
	| workflow |
	workflow := GtRlReleaserExportWorkflow
			forBaseline: self baselineClass
			fromRepository: self repositoryMetacelloUrl
			withConfiguration: self releaseConfiguration.
	^ workflow
]

{ #category : #'api - configuration' }
GtRlReleaseExporter >> enforcedVersion: aVersion [ 
	self releaseConfiguration
		enforcedVersion: aVersion
]

{ #category : #'api - configuration' }
GtRlReleaseExporter >> forceNewRelease [
	self releaseConfiguration forceNewRelease
]

{ #category : #testing }
GtRlReleaseExporter >> hasBaselineClass [
	^ baselineClass isNotNil
]

{ #category : #testing }
GtRlReleaseExporter >> hasReleaseConfiguration [
	^ releaseConfiguration isNotNil
]

{ #category : #testing }
GtRlReleaseExporter >> hasRepositoryMetacelloUrl [
	^ repositoryMetacelloUrl isNotNil
]

{ #category : #'api - building' }
GtRlReleaseExporter >> nextReleaseVersion [
	| workflow | 
	workflow := self buildReleaseWorkflow.
	^ workflow rootProjectRelease version
]

{ #category : #'api - building' }
GtRlReleaseExporter >> performRelease [
	| workflow | 
	workflow := self buildReleaseWorkflow.
	workflow executeReleaseActions.
]

{ #category : #'api - building' }
GtRlReleaseExporter >> printNewCommitsToFile [
	| workflow | 
	workflow := self buildReleaseWorkflow.
	workflow printNewCommitsToFile
]

{ #category : #accessing }
GtRlReleaseExporter >> releaseConfiguration [
	<return: #GtRlReleaseConfiguration>
	self
		assert: [ releaseConfiguration isNotNil ]
		description: [ 'Release configuration must be non-nil' ].
	^ releaseConfiguration
]

{ #category : #'api - initialization' }
GtRlReleaseExporter >> releaseConfiguration: aGtRlReleaseConfiguration [
	releaseConfiguration := aGtRlReleaseConfiguration
]

{ #category : #accessing }
GtRlReleaseExporter >> repositoryMetacelloUrl [
	"Return Metacello URL similar to github://feenkcom/gtookit:main/src, 
	referring to a project repository for which release should happen."

	<return: #String>
	self
		assert: [ repositoryMetacelloUrl isNotNil ]
		description: [ 'Repository metacello URL must be non-nil' ].
	^ repositoryMetacelloUrl
]

{ #category : #'api - initialization' }
GtRlReleaseExporter >> repositoryMetacelloUrl: aString [
	repositoryMetacelloUrl := aString
]
