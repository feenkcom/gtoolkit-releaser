Class {
	#name : #GtRlLeafProjectReleaseStrategy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlLeafProjectReleaseStrategy >> description [
	^ 'LeafRelease'
]

{ #category : #initialization }
GtRlLeafProjectReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		releaseBranchName: aRepositoryRelease icebergRepository branchName
]

{ #category : #accessing }
GtRlLeafProjectReleaseStrategy >> updateFor: anUpdateWorkflow [
	| latestVersionTag |
	
	"1. If a new release if explicitly requested created it."
	self shouldForceNewRelease ifTrue: [ 
		^ self configureNewVersionRelease ].
	
	"2. If there is no release tag in the repository a new release is needed."
	self repositoryRelease semanticVersionTags ifEmpty: [
		^ self configureNewVersionRelease ].
	
	"3. If the latest release is not the head commit of the release branch generate a new release."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	(latestVersionTag commit = self releaseBranch commit) ifFalse: [
		^ self configureNewVersionRelease ].
	
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber) emit.
	
	"Use the latest releae instead of generating a new one."
	^ self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber;
		makePassiveRelease
]

{ #category : #'actions - building' }
GtRlLeafProjectReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	| commitAction |
	self repositoryRelease resetReleaseActions.
	self repositoryRelease isPassiveRelease ifTrue: [ ^ self ].
	
	commitAction := GtRlCommitAndTagReleaseAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: commitAction.
	
]
