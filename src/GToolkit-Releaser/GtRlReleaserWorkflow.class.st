Class {
	#name : #GtRlReleaserWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootProjectRelease',
		'releaseActions'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'private - actions' }
GtRlReleaserWorkflow >> addReleaseAction: aReleaseAction [
	self releaseActions addAction: aReleaseAction
]

{ #category : #initialization }
GtRlReleaserWorkflow >> createReleaseActions [
	| order |
	order := 0.
	self releaseActions ifNotEmpty: [ Error signal: 'Release actions already created' ].
	self repositoriesReleasesInReleaseOrder do: [ :aRepositoryRelease |
		|  mergeAction commitAction |
		mergeAction := GtRlMergeToReleaseBranchAction forRepositoryRelease: aRepositoryRelease.
		mergeAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: mergeAction.
		self addReleaseAction: mergeAction.
		(aRepositoryRelease projectReleases reject: #isLeaf) do: [ :aProjectRelease | 
			| baselineAction |
			baselineAction := GtRlCompileBaselineReleaseAction forProjectRelease: aProjectRelease.
			baselineAction order: (order := order + 1).
			aProjectRelease addReleaseAction: baselineAction.
			self addReleaseAction: baselineAction ].
		commitAction := GtRlCommitAndTagReleaseAction forRepositoryRelease: aRepositoryRelease.
		commitAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: commitAction.
		self addReleaseAction: commitAction ].
	
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtProjectMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease gtProjectMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtRepoMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease repositoryRelease gtRepoMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtRepositoryReleasesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releases' translated;
		items: [ self repositoriesReleasesInReleaseOrder ];
		column: 'Repository' item: [ :aRepositoryRelease | aRepositoryRelease repository id ];
		column: 'Version' item: [ :aRepositoryRelease | aRepositoryRelease versionString ];
		column: 'Release strategy' item: [ :aRepositoryRelease | aRepositoryRelease releaseStrategy releaseTarget ]
]

{ #category : #accessing }
GtRlReleaserWorkflow >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := GtRlReleaseActionsGroup new ]
]

{ #category : #accessing }
GtRlReleaserWorkflow >> repositoriesReleasesInReleaseOrder [
	^ self rootProjectRelease repositoryRelease allChildRepositoryReleases reverse reject: [ :aRelease |
		aRelease isPassiveRelease ]
]

{ #category : #accessing }
GtRlReleaserWorkflow >> rootProjectRelease [
	^ rootProjectRelease
]

{ #category : #accessing }
GtRlReleaserWorkflow >> rootProjectRelease: aProjectRelease [
	rootProjectRelease := aProjectRelease
]
