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
	self releaseActions add: aReleaseAction
]

{ #category : #initialization }
FkRlReleaserWorkflow >> createReleaseActions [
	self releaseActions ifNotEmpty: [ Error signal: 'Release actions already created' ].
	self rootProjectRelease repositoryRelease allChildRepositoryReleases reverseDo: [ :aRepositoryRelease |
		|  mergeAction commitAction |
		mergeAction := FkRlMergeToReleaseBranchAction forRepositoryRelease: aRepositoryRelease.
		aRepositoryRelease addReleaseAction: mergeAction.
		self addReleaseAction: mergeAction.
		aRepositoryRelease projectReleases do: [ :aProjectRelease | 
			| baselineAction |
			baselineAction := FkRlCompileBaselineReleaseAction forProjectRelease: aProjectRelease.
			aProjectRelease addReleaseAction: baselineAction.
			self addReleaseAction: baselineAction ].
		commitAction := FkRlCommitAndTagReleaseAction forRepositoryRelease: aRepositoryRelease.
		aRepositoryRelease addReleaseAction: mergeAction.
		self addReleaseAction: commitAction ].
	
]

{ #category : #accessing }
FkRlReleaserWorkflow >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := OrderedCollection new ]
]

{ #category : #accessing }
FkRlReleaserWorkflow >> rootProjectRelease [
	^ rootProjectRelease
]

{ #category : #accessing }
FkRlReleaserWorkflow >> rootProjectRelease: aProjectRelease [
	rootProjectRelease := aProjectRelease
]
