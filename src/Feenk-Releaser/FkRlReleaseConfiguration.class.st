Class {
	#name : #FkRlReleaseConfiguration,
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
FkRlReleaseConfiguration >> customReleaseBranches [
	^ customReleaseBranches ifNil: [ 
		customReleaseBranches := Dictionary new ]
]

{ #category : #accessing }
FkRlReleaseConfiguration >> customVersionComputations [
	^ customVersionComputations ifNil: [ 
		customVersionComputations := Dictionary new ]
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultReleaseBranchName [
	^ defaultReleaseBranchName
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultReleaseBranchName: aBranchName [
	defaultReleaseBranchName := aBranchName
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultVersionComputation [
	^ defaultVersionComputation
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultVersionComputation: aVersionComputation [
	defaultVersionComputation := aVersionComputation
]

{ #category : #actions }
FkRlReleaseConfiguration >> ignoreProject: aProjectId [
	self ignoredProjects add: aProjectId
]

{ #category : #actions }
FkRlReleaseConfiguration >> ignoreProjects: aColectionOfProjectsIds [
	self ignoredProjects addAll: aColectionOfProjectsIds
]

{ #category : #accessing }
FkRlReleaseConfiguration >> ignoredProjects [
	^ ignoredProjects ifNil: [ 
		ignoredProjects := OrderedCollection new ]
]

{ #category : #'accessing - dynamic' }
FkRlReleaseConfiguration >> releaseBranchForRepository: aRepository [
	^ self customReleaseBranches 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseBranchName ]
]

{ #category : #'accessing - dynamic' }
FkRlReleaseConfiguration >> releaseVersionForRepository: aRepository [
	| versionComputation |
	versionComputation := self customVersionComputations 
		at: aRepository id 
		ifAbsent: [ self defaultVersionComputation ].
	^ versionComputation releaseVersionForRepository: aRepository
]

{ #category : #actions }
FkRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]

{ #category : #actions }
FkRlReleaseConfiguration >> setVersionComputation: aVersionComputation forProjectId: aProjectId [
	self customVersionComputations 
		at: aProjectId put: aVersionComputation
]

{ #category : #actions }
FkRlReleaseConfiguration >> setVersionComputationOfType: aVersionComputationType forProjecs: aListOfProjectIds [
	aListOfProjectIds do: [ :aProjectId |
		self setVersionComputation: aVersionComputationType new forProjectId: aProjectId  ]
	
]

{ #category : #accessing }
FkRlReleaseConfiguration >> shouldIgnoreProject: aProjectId [
	^ self ignoredProjects includes: aProjectId
]
