"
I model options for configuring how releases are performed.

I am used by a {{gtClass:GtRlReleaseBuilder}} to create a new release. Users can configure default options that apply to all repositories from a release, or configure options for individual repositories.

My main API methods for setting other default options are:
- {{gtMethod:GtRlReleaseConfiguration>>#defaultReleaseBranchName:}} The branch name on which to perform the release.
- {{gtMethod:GtRlReleaseConfiguration>>#defaultVersionComputation:}} The strategy for computing the next version number in case a version already exists. These are subclasses of {{gtClass:GtRlSemanticVersionComputation}};
- {{gtMethod:GtRlReleaseConfiguration>>#defaultVersionNumber:}} The version number to use in case there are no previous releases in a repository.
- {{gtMethod:GtRlReleaseConfiguration>>#forceNewRelease}} Force a new release in a repository even if there no new changes in that repository and all dependencies did not change.

By default I use a release strategy of type {{gtClass:GtRlDedicatedBranchReleaseStrategy}}. However, a custom release strategy can be configured for each indivual project using the method {{gtMethod:GtRlReleaseConfiguration>>#setReleaseStrategyOfType:forProjecs:}}.


"
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
		'enforcedVersion',
		'defaultReleaseStrategy'
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
	^ defaultReleaseStrategy ifNil: [
		 GtRlDedicatedBranchReleaseStrategy new]
]

{ #category : #accessing }
GtRlReleaseConfiguration >> defaultReleaseStrategy: aDefaultReleaseStrategy [
	defaultReleaseStrategy := aDefaultReleaseStrategy
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
		priority: 5;
		items: [ { 
			'Release strategy' -> self defaultReleaseStrategy.
			'Release branch' -> self defaultReleaseBranchName.
			'Version number' -> self defaultVersionNumber.
			'Version computation' -> self defaultVersionComputation.
			'Force release' -> self defaultShouldForceNewRelease } ];
		column: 'Option' text: #key;
		column: 'Default value' text: #value;
		send: #value
]

{ #category : #ui }
GtRlReleaseConfiguration >> gtViewCustomReleaseStrategiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Custom Strategies';
		priority: 10;
		items: [ customReleaseStrategies associations ];
		column: 'Repository Spec' text: [ :assoc | assoc key ];
		column: 'Release strategy' text: [ :assoc | assoc value description ];
		send: [ :assoc | assoc value ]
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
