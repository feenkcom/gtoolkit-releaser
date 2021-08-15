"
I model a release for a project by decorating a {{gtClass:GtRlProject}} instance with a concrete version.

I do not store my own version version. Instead I used the version number of the repository release that contains me. This is the case as all project releases from a repository should have the same release version number. 

I can also have an empty list of actions if there is nothing to be done at the project level for creating the release. I do not have my own release strategy like repository releases. Instead the release strategy of the {{gtClass:GtRlRepositoryRelease}} that contains me is responsible for adding actions. Currently the design is like this as there are only few actions needed at the project level.

I have as main attributes:
	- project: the {{gtClass:GtRlProject}} for which I do a release;
	- repositoryRelease: the repository release containing this project release;
	- parentReleases and childReleases: the parent and child project releases corresponding to the parent and child releases from that project that I reference.


"
Class {
	#name : 'GtRlProjectRelease',
	#superclass : 'GtRlRelease',
	#instVars : [
		'project',
		'repositoryRelease',
		'parentReleases',
		'childReleases'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : 'instance creation' }
GtRlProjectRelease class >> forBaseline: aBaselineClass fromRepository: aRepositoryUrl withConfiguration: aReleaseConfiguration [
	| releaseBuilder project |
	project := aBaselineClass gtRlProjectWithRepository: aRepositoryUrl.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: aReleaseConfiguration. 
	^ releaseBuilder buildReleaseForProject: project.
]

{ #category : 'instance creation' }
GtRlProjectRelease class >> forProject: aProject [
	^ self new
		project: aProject
]

{ #category : 'accessing' }
GtRlProjectRelease >> addChildRelease: aProjectRelease [
	aProjectRelease parentReleases add: self.
	self childReleases add: aProjectRelease.
]

{ #category : 'accessing - dynamic' }
GtRlProjectRelease >> baselineGenerator [
	^ self project baselineGenerator releaseBaselineGenerator 
		projectRelease: self
]

{ #category : 'accessing' }
GtRlProjectRelease >> childReleases [
	^ childReleases ifNil: [ 
		childReleases := OrderedCollection new ]
]

{ #category : 'actions' }
GtRlProjectRelease >> compileBaselineMethod [
 	^ self baselineGenerator compileBaselineMethod
]

{ #category : 'actions' }
GtRlProjectRelease >> generateBaselineSource [
 	^ self baselineGenerator generateBaselineSource
]

{ #category : 'ui' }
GtRlProjectRelease >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new classOrMetaClass: ('BaselineOf', self project name) asClass);
		title: 'Release source' translated;
		text: [ self generateBaselineSource ];
		priority: 15
]

{ #category : 'ui' }
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
			mondrian layout custom: GtGradWestHierarchicalLayout new ]
]

{ #category : 'ui' }
GtRlProjectRelease >> gtRepoMapFor: aView [
	<gtView>
	^ self repositoryRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepositoryRelease | aRepositoryRelease gtRepoMapFor: aView ]
]

{ #category : 'testing' }
GtRlProjectRelease >> isLeaf [
	^ self project isLeaf
]

{ #category : 'accessing' }
GtRlProjectRelease >> name [
	^ self project name.
]

{ #category : 'actions' }
GtRlProjectRelease >> nodeName [
	^ project name
]

{ #category : 'accessing' }
GtRlProjectRelease >> parentReleases [
	^ parentReleases ifNil: [ 
		parentReleases := OrderedCollection new ]
]

{ #category : 'printing' }
GtRlProjectRelease >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self project name.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self repositoryRelease releaseDetailsDescription.
	aStream nextPutAll: ')'
]

{ #category : 'accessing' }
GtRlProjectRelease >> project [
	^ project
]

{ #category : 'accessing' }
GtRlProjectRelease >> project: aProject [
	project := aProject
]

{ #category : 'accessing' }
GtRlProjectRelease >> repositoryRelease [
	^ repositoryRelease
]

{ #category : 'accessing' }
GtRlProjectRelease >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]

{ #category : 'accessing' }
GtRlProjectRelease >> version [
	^ self repositoryRelease version
]

{ #category : 'traversing' }
GtRlProjectRelease >> withAllChildProjectReleases [
	^ self withDeepCollect: #childReleases
]
