Class {
	#name : #GtRlTravisRepository,
	#superclass : #Object,
	#instVars : [
		'repository',
		'builds',
		'repositoryData',
		'buildData',
		'buildsData'
	],
	#category : #'GToolkit-Releaser-TravisExplorer'
}

{ #category : #ui }
GtRlTravisRepository >> gtProjectBuildsFor: aView [
	<gtView>
	^ builds 
		ifNil: [ aView ]
		ifNotNil: [ (builds gtItemsFor: aView) 
			title: 'Latest builds' translated ]
]

{ #category : #ui }
GtRlTravisRepository >> gtRepositoryDataFor: aView [
	<gtView>
	^ repositoryData 
		ifNil: [ aView ]
		ifNotNil: [ (repositoryData gtItemsFor: aView) 
			title: 'Raw data' translated ]
]

{ #category : #accessing }
GtRlTravisRepository >> repository [
	^ repository
]

{ #category : #accessing }
GtRlTravisRepository >> repository: aRepository [
	repository := aRepository
]

{ #category : #'as yet unclassified' }
GtRlTravisRepository >> travisClient [
	^ ZnClient new
		headerAt: 'Accept' put: 'application/vnd.travis-ci.2.1+json';
		headerAt: 'Travis-API-Version' put: '3';
		headerAt: 'User-Agent' put: 'MyEngine/1.0.0';
		contentReader: [ :entity | STONJSON fromString: entity contents ].
]

{ #category : #'as yet unclassified' }
GtRlTravisRepository >> updateTravisData [
	repositoryData := self travisClient get: 'https://api.travis-ci.org/repo/feenkcom%2Fgtoolkit'.
	buildsData := self travisClient get: 'https://api.travis-ci.org/repo/feenkcom%2Fgtoolkit/builds?limit=10'.
	builds := (buildsData at: 'builds') collect: [ :aBuildData |
		GtRlTravisBuild new
			travisProject: self;
			buildData: aBuildData ]
]
