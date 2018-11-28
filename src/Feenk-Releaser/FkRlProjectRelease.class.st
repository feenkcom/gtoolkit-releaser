Class {
	#name : #FkRlProjectRelease,
	#superclass : #FkRlRelease,
	#instVars : [
		'project',
		'repositoryRelease',
		'parentReleases',
		'childReleases'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlProjectRelease >> addChildRelease: aProjectRelease [
	aProjectRelease parentReleases add: self.
	self childReleases add: aProjectRelease.
]

{ #category : #accessing }
FkRlProjectRelease >> childReleases [
	^ childReleases ifNil: [ 
		childReleases := OrderedCollection new ]
]

{ #category : #ui }
FkRlProjectRelease >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Release source';
		text: [ self project generateSourceWithSemanticVersion: self version versionString];
		priority: 15
]

{ #category : #accessing }
FkRlProjectRelease >> parentReleases [
	^ parentReleases ifNil: [ 
		parentReleases := OrderedCollection new ]
]

{ #category : #printing }
FkRlProjectRelease >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self project name.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self version versionString.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
FkRlProjectRelease >> project [
	^ project
]

{ #category : #accessing }
FkRlProjectRelease >> project: aProject [
	project := aProject
]

{ #category : #accessing }
FkRlProjectRelease >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
FkRlProjectRelease >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]

{ #category : #accessing }
FkRlProjectRelease >> version [
	^ self repositoryRelease version
]
