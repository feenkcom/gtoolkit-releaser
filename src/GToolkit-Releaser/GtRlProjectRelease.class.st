Class {
	#name : #GtRlProjectRelease,
	#superclass : #GtRlRelease,
	#instVars : [
		'project',
		'repositoryRelease',
		'parentReleases',
		'childReleases'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlProjectRelease >> addChildRelease: aProjectRelease [
	aProjectRelease parentReleases add: self.
	self childReleases add: aProjectRelease.
]

{ #category : #traversing }
GtRlProjectRelease >> allChildReleaseDo: aBloc [
	aBloc value: self.
	self childReleases do: aBloc
]

{ #category : #'accessing - dynamic' }
GtRlProjectRelease >> childProjectsWithRepositoryURL [
	^ self childReleases collect: [ :aRelease |
		aRelease project name -> {aRelease repositoryRelease urlWithReleaseVersion asString} ]
]

{ #category : #accessing }
GtRlProjectRelease >> childReleases [
	^ childReleases ifNil: [ 
		childReleases := OrderedCollection new ]
]

{ #category : #actions }
GtRlProjectRelease >> compileBaselineMethod [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self project compileBaselineWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : #actions }
GtRlProjectRelease >> generateBaselineSource [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self project generateSourceWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : #ui }
GtRlProjectRelease >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Release source' translated;
		text: [ self generateBaselineSource ];
		priority: 15
]

{ #category : #ui }
GtRlProjectRelease >> gtRepoMapFor: aView [
	<gtView>
	^ self repositoryRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepositoryRelease | aRepositoryRelease gtRepoMapFor: aView ]
]

{ #category : #testing }
GtRlProjectRelease >> isLeaf [
	^ self project isLeaf
]

{ #category : #testing }
GtRlProjectRelease >> isPassiveRelease [
	^ self repositoryRelease isPassiveRelease
]

{ #category : #accessing }
GtRlProjectRelease >> parentReleases [
	^ parentReleases ifNil: [ 
		parentReleases := OrderedCollection new ]
]

{ #category : #printing }
GtRlProjectRelease >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self project name.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self repositoryRelease releaseDetailsDescription.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
GtRlProjectRelease >> project [
	^ project
]

{ #category : #accessing }
GtRlProjectRelease >> project: aProject [
	project := aProject
]

{ #category : #accessing }
GtRlProjectRelease >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlProjectRelease >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]

{ #category : #accessing }
GtRlProjectRelease >> version [
	^ self repositoryRelease version
]
