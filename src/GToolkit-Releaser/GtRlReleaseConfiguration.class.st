Class {
	#name : #GtRlReleaseConfiguration,
	#superclass : #Object,
	#instVars : [
		'defaultReleaseBranchName',
		'customReleaseBranches',
		'defaultVersionComputation',
		'customVersionComputations',
		'customReleaseStrategies',
		'shouldForceNewRelease',
		'defaultVersionNumber',
		'enforcedVersion'
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
	^ defaultReleaseBranchName ifNil: [ 'release' ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultReleaseBranchName: aBranchName [
	defaultReleaseBranchName := aBranchName
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultReleaseStrategy [
	^ GtRlDedicatedBranchReleaseStrategy new
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultShouldForceNewRelease [
	^ false
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation [
	^ defaultVersionComputation ifNil: [ 
		GtRlPatchVersionComputation new ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionComputation: aVersionComputation [
	defaultVersionComputation := aVersionComputation
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionNumber [
	^ defaultVersionNumber ifNil: [ 
		GtRlSemanticVersionNumber major:0 minor: 1 patch: 0 ]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultVersionNumber: aVersionNumber [
	defaultVersionNumber := aVersionNumber
]

{ #category : #logging }
GtRlReleaseConfiguration >> emit [
	^ GtRlReleaseConfigurationSignal emit: self.
]

{ #category : #accessing }
GtRlReleaseConfiguration >> enforcedVersion [
	^ enforcedVersion
]

{ #category : #accessing }
GtRlReleaseConfiguration >> enforcedVersion: version [
	enforcedVersion := version
]

{ #category : #accessing }
GtRlReleaseConfiguration >> forceNewRelease [
	shouldForceNewRelease := true
]

{ #category : #ui }
GtRlReleaseConfiguration >> gtDefaultOptionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Defaults';
		items: [ { 
			'Release strategy' -> self defaultReleaseStrategy.
			'Release branch' -> self defaultReleaseBranchName.
			'Version number' -> self defaultVersionNumber.
			'Version computation' -> self defaultVersionComputation.
			'Force release' -> self defaultShouldForceNewRelease } ];
		column: 'Option' item: #key;
		column: 'Default value' item: #value;
		send: #value
]

{ #category : #'options - accessing' }
GtRlReleaseConfiguration >> releaseBranchForRepository: aRepository [
	^ self customReleaseBranches 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseBranchName ]
]

{ #category : #'options - accessing' }
GtRlReleaseConfiguration >> releaseStrategyForRepository: aRepository [
	^ self customReleaseStrategies 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseStrategy ]
]

{ #category : #'options - accessing' }
GtRlReleaseConfiguration >> releaseVersionComputationForRepository: aRepository [
	| versionComputation |
	versionComputation := self customVersionComputations 
		at: aRepository id 
		ifAbsent: [ self defaultVersionComputation ].
	versionComputation defaultVersionNumber: self defaultVersionNumber.
	^ versionComputation
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseStrategy: aReleaseStrategy forProjectId: aProjectId [
	(GtRlProjectReleaseStrategySignal project: aProjectId strategy: aReleaseStrategy) emit.
	self customReleaseStrategies 
		at: aProjectId put: aReleaseStrategy
]

{ #category : #actions }
GtRlReleaseConfiguration >> setReleaseStrategyOfType: aReleaseStrategy forProjecs: aListOfProjectIds [
	aListOfProjectIds do: [ :aProjectId |
		self setReleaseStrategy: aReleaseStrategy new forProjectId: aProjectId ]
	
]

{ #category : #'options - accessing' }
GtRlReleaseConfiguration >> shouldForceNewRelease [
	^ shouldForceNewRelease ifNil: [ false ]
]
