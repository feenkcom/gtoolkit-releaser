Class {
	#name : 'GtRlProjectLinkWithRepositorySignal',
	#superclass : 'GtReleaserSignal',
	#instVars : [
		'projectName',
		'repositoryName',
		'project',
		'repository'
	],
	#category : 'GToolkit-Releaser-Logging'
}

{ #category : 'as yet unclassified' }
GtRlProjectLinkWithRepositorySignal class >> project: aProject repository: aRepository [
	^ self new
	  project: aProject;
	  repository: aRepository.
]

{ #category : 'accessing' }
GtRlProjectLinkWithRepositorySignal >> printOneLineContentsOn: stream [
	stream nextPutAll: project name; nextPutAll: ' -> '; nextPutAll: repository repositoryName 
]

{ #category : 'accessing' }
GtRlProjectLinkWithRepositorySignal >> project: aProject [
	project := aProject
]

{ #category : 'accessing' }
GtRlProjectLinkWithRepositorySignal >> repository: aRepository [
	repository := aRepository 
]
