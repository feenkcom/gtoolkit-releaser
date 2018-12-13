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
GtRlProjectRelease >> gtProjectMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 60;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProjectRelease ||textColor|
					textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					BlTextElement new 
						text: ((
							aProjectRelease project name, 
							', ', aProjectRelease repositoryRelease releaseDetailsDescription
						) asRopedText foreground: textColor) ];
				with: (self withDeepCollect: #childReleases).
			mondrian edges
				shape: [
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childReleases.
			mondrian layout horizontalDominanceTree 
				nodeDistance: 10; 
				levelDistance: 10 ]
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
