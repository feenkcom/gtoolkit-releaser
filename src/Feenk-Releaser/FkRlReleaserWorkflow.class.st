Class {
	#name : #FkRlReleaserWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootProjectRelease',
		'releaseActions'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'private - actions' }
FkRlReleaserWorkflow >> addReleaseAction: aReleaseAction [
	self releaseActions addAction: aReleaseAction
]

{ #category : #initialization }
FkRlReleaserWorkflow >> createReleaseActions [
	| order |
	order := 0.
	self releaseActions ifNotEmpty: [ Error signal: 'Release actions already created' ].
	self repositoriesReleasesInReleaseOrder do: [ :aRepositoryRelease |
		|  mergeAction commitAction |
		mergeAction := FkRlMergeToReleaseBranchAction forRepositoryRelease: aRepositoryRelease.
		mergeAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: mergeAction.
		self addReleaseAction: mergeAction.
		(aRepositoryRelease projectReleases reject: #isLeaf) do: [ :aProjectRelease | 
			| baselineAction |
			baselineAction := FkRlCompileBaselineReleaseAction forProjectRelease: aProjectRelease.
			baselineAction order: (order := order + 1).
			aProjectRelease addReleaseAction: baselineAction.
			self addReleaseAction: baselineAction ].
		commitAction := FkRlCommitAndTagReleaseAction forRepositoryRelease: aRepositoryRelease.
		commitAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: commitAction.
		self addReleaseAction: commitAction ].
	
]

{ #category : #ui }
FkRlReleaserWorkflow >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #ui }
FkRlReleaserWorkflow >> gtRepoMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease repositoryRelease gtRepoMapFor: aView ]
]

{ #category : #ui }
FkRlReleaserWorkflow >> gtRepositoryReleasesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releases' translated;
		items: [ self repositoriesReleasesInReleaseOrder ];
		column: 'Repository' item: [ :aRepositoryRelease | aRepositoryRelease repository id ];
		column: 'Version' item: [ :aRepositoryRelease | aRepositoryRelease versionString ];
		column: 'Release strategy' item: [ :aRepositoryRelease | aRepositoryRelease releaseStrategy releaseTarget ]
]

{ #category : #accessing }
FkRlReleaserWorkflow >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := FkRlReleaseActionsGroup new ]
]

{ #category : #accessing }
FkRlReleaserWorkflow >> repositoriesReleasesInReleaseOrder [
	^ self rootProjectRelease repositoryRelease allChildRepositoryReleases reverse reject: [ :aRelease |
		aRelease isPassiveRelease ]
]

{ #category : #accessing }
FkRlReleaserWorkflow >> rootProjectRelease [
	^ rootProjectRelease
]

{ #category : #accessing }
FkRlReleaserWorkflow >> rootProjectRelease: aProjectRelease [
	rootProjectRelease := aProjectRelease
]
