Class {
	#name : #GtRlReleaseConfiguration,
	#superclass : #Object,
	#instVars : [
		'defaultReleaseBranchName',
		'customReleaseBranches',
		'defaultVersionComputation',
		'customVersionComputations',
		'ignoredProjects'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlReleaseConfiguration >> customReleaseBranches [
	^ customReleaseBranches ifNil: [ 
		customReleaseBranches := Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> customVersionComputations [
	^ customVersionComputations ifNil: [ 
		customVersionComputations := Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultReleaseBranchName [
	^ defaultReleaseBranchName
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultReleaseBranchName: aBranchName [
	defaultReleaseBranchName := aBranchName
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation [
	^ defaultVersionComputation
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation: aVersionComputation [
	defaultVersionComputation := aVersionComputation
]

{ #category : #actions }
GtRlReleaseConfiguration >> ignoreProject: aProjectId [
	self ignoredProjects add: aProjectId
]

{ #category : #actions }
GtRlReleaseConfiguration >> ignoreProjects: aColectionOfProjectsIds [
	self ignoredProjects addAll: aColectionOfProjectsIds
]

{ #category : #accessing }
GtRlReleaseConfiguration >> ignoredProjects [
	^ ignoredProjects ifNil: [ 
		ignoredProjects := OrderedCollection new ]
]

{ #category : #'accessing - dynamic' }
GtRlReleaseConfiguration >> releaseBranchForRepository: aRepository [
	^ self customReleaseBranches 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseBranchName ]
]

{ #category : #'accessing - dynamic' }
GtRlReleaseConfiguration >> releaseVersionForRepository: aRepository [
	| versionComputation |
	versionComputation := self customVersionComputations 
		at: aRepository id 
		ifAbsent: [ self defaultVersionComputation ].
	^ versionComputation releaseVersionForRepository: aRepository
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]

{ #category : #actions }
GtRlReleaseConfiguration >> setVersionComputation: aVersionComputation forProjectId: aProjectId [
	self customVersionComputations 
		at: aProjectId put: aVersionComputation
]

{ #category : #actions }
GtRlReleaseConfiguration >> setVersionComputationOfType: aVersionComputationType forProjecs: aListOfProjectIds [
	aListOfProjectIds do: [ :aProjectId |
		self setVersionComputation: aVersionComputationType new forProjectId: aProjectId  ]
	
]

{ #category : #accessing }
GtRlReleaseConfiguration >> shouldIgnoreProject: aProjectId [
	^ self ignoredProjects includes: aProjectId
]
