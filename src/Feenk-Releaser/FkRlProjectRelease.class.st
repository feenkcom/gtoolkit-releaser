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

{ #category : #traversing }
FkRlProjectRelease >> allChildReleaseDo: aBloc [
	aBloc value: self.
	self childReleases do: aBloc
]

{ #category : #'accessing - dynamic' }
FkRlProjectRelease >> childProjectsWithRepositoryURL [
	^ self childReleases collect: [ :aRelease |
		aRelease project name -> {aRelease repositoryRelease urlWithReleaseVersion asString} ]
]

{ #category : #accessing }
FkRlProjectRelease >> childReleases [
	^ childReleases ifNil: [ 
		childReleases := OrderedCollection new ]
]

{ #category : #actions }
FkRlProjectRelease >> compileBaselineMethod [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self project compileBaselineWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : #actions }
FkRlProjectRelease >> generateBaselineSource [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self project generateSourceWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : #ui }
FkRlProjectRelease >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Release source' translated;
		text: [ self generateBaselineSource ];
		priority: 15
]

{ #category : #ui }
FkRlProjectRelease >> gtRepoMapFor: aView [
	<gtView>
	^ self repositoryRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepositoryRelease | aRepositoryRelease gtRepoMapFor: aView ]
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
	aStream nextPutAll: self repositoryRelease releaseDetailsDescription.
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
