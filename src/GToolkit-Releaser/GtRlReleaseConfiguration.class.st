Class {
	#name : #GtRlReleaseConfiguration,
	#superclass : #Object,
	#instVars : [
		'defaultReleaseBranchName',
		'customReleaseBranches',
		'defaultVersionComputation',
		'customVersionComputations',
		'customReleaseStrategies',
		'shouldForceNewRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlReleaseConfiguration >> customReleaseBranches [
	^ customReleaseBranches ifNil: [ 
		customReleaseBranches := Dictionary new ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> customReleaseStrategies [
	^ customReleaseStrategies ifNil: [ 
		customReleaseStrategies := Dictionary new ]
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
GtRlReleaseConfiguration >> defaultReleaseStrategy [
	^ GtRlDedicatedReleaseBranchStragegy new
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation [
	^ defaultVersionComputation
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation: aVersionComputation [
	defaultVersionComputation := aVersionComputation
]

{ #category : #accessing }
GtRlReleaseConfiguration >> forceNewRelease [
	shouldForceNewRelease := true
]

{ #category : #'accessing - dynamic' }
GtRlReleaseConfiguration >> releaseBranchForRepository: aRepository [
	^ self customReleaseBranches 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseBranchName ]
]

{ #category : #'accessing - dynamic' }
GtRlReleaseConfiguration >> releaseStrategyForRepository: aRepository [
	^ self customReleaseStrategies 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseStrategy ]
]

{ #category : #'accessing - dynamic' }
GtRlReleaseConfiguration >> releaseVersionComputationForRepository: aRepository [
	^ self customVersionComputations 
		at: aRepository id 
		ifAbsent: [ self defaultVersionComputation ]
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseStrategy: aReleaseStrategy forProjectId: aProjectId [
	self customReleaseStrategies 
		at: aProjectId put: aReleaseStrategy
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseStrategyOfType: aReleaseStrategy forProjecs: aListOfProjectIds [
	aListOfProjectIds do: [ :aProjectId |
		self setReleaseStrategy: aReleaseStrategy new forProjectId: aProjectId ]
	
]

{ #category : #accessing }
GtRlReleaseConfiguration >> shouldForceNewRelease [
	^ shouldForceNewRelease ifNil: [ false ]
]
