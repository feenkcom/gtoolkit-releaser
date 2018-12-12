Class {
	#name : #GtRlDedicatedBranchReleaseStragegy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#instVars : [
		'releaseBranchName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #actions }
GtRlDedicatedBranchReleaseStragegy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #printing }
GtRlDedicatedBranchReleaseStragegy >> description [
	^ 'Branch #', (self releaseBranchName ifNil: [ 'missing' ])
]

{ #category : #ui }
GtRlDedicatedBranchReleaseStragegy >> gtCommitsAncestryFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Commits ancestry' translated;
		priority: 100;
		painting: [ :view | 
			| commitColor commitsReleaseBranch commitsReferenceBranch |
			commitsReleaseBranch :=  self releaseBranch commits.
			commitsReferenceBranch := self referenceBranch commits.
			view nodes 
				stencil: [ :aCommit |
					| element |
					element := BlElement new.
					element 	
						geometry: BlEllipse new;
						border: (BlBorder paint: Color black width: 1);
						size: 10@10;
						constraintsDo: [ :constraints | 
							constraints padding: (BlInsets all: 5) ].
					commitColor := Color white.
					(commitsReferenceBranch includes: aCommit)
						ifTrue: [ commitColor := Color orange lighter ].
					(aCommit tags anySatisfy: #gtIsSemanticVersion)
						ifTrue: [ commitColor := Color blue ].
					element background: commitColor.
					element ];
				with: commitsReleaseBranch asSet, commitsReferenceBranch.
			view edges connectToAll: #ancestors.
			view layout dominanceTree]
]

{ #category : #initialization }
GtRlDedicatedBranchReleaseStragegy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		releaseBranchName: (aReleaseConfiguration releaseBranchForRepository: aRepositoryRelease repository)
]

{ #category : #'private - actions' }
GtRlDedicatedBranchReleaseStragegy >> isReferenceBranchMergedIn: anIceCommit [
	| latestRefenceBranchCommit |
	latestRefenceBranchCommit := self referenceBranch commit.
	^ anIceCommit isParentOf: latestRefenceBranchCommit
]

{ #category : #actions }
GtRlDedicatedBranchReleaseStragegy >> mergeToReleaseBranch [
	| icebergRepository |
	icebergRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName
]

{ #category : #'accessing - dynamic' }
GtRlDedicatedBranchReleaseStragegy >> releaseBranch [
	^ self repositoryRelease icebergRepository branchNamed: self releaseBranchName 
]

{ #category : #accessing }
GtRlDedicatedBranchReleaseStragegy >> releaseBranchName [
	^ releaseBranchName
]

{ #category : #accessing }
GtRlDedicatedBranchReleaseStragegy >> releaseBranchName: aBranchName [
	releaseBranchName := aBranchName
]

{ #category : #actions }
GtRlDedicatedBranchReleaseStragegy >> updateFor: anUpdateWorkflow [
	| latestVersionTag releaseMetadata|
	"1. If a new release if explicitly requested created it."
	self shouldForceNewRelease ifTrue: [ 
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"2. If there is no release tag in the repository a new release is needed."
	self repositoryRelease semanticVersionTags ifEmpty: [
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"3. If the latest release tag does not include the latest commit from the reference branch generate a new release."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	(self isReferenceBranchMergedIn: latestVersionTag commit) ifFalse: [
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"4. If any dependency has a different version than in the current release generate a new release."
	releaseMetadata := GtRlReleaseVersionMetadata fromCommit: latestVersionTag commit.
	(self repositoryRelease matchesDependenciesIn: releaseMetadata) ifFalse: [
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	^ self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber;
		resetReleaseActions
]

{ #category : #'private - actions' }
GtRlDedicatedBranchReleaseStragegy >> updateReleaseActionsUsing: anUpdateWorkflow [
	| mergeAction commitAction metadataAction |
	self repositoryRelease resetReleaseActions.
	
	mergeAction := GtRlMergeToReleaseBranchAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: mergeAction.

	(self repositoryRelease projectReleases reject: #isLeaf) do: [ :aProjectRelease | 
		| baselineAction |
		baselineAction := GtRlCompileBaselineReleaseAction new
			projectRelease: aProjectRelease;
			order: anUpdateWorkflow nextActionOrder.
		aProjectRelease addReleaseAction: baselineAction ].
		
	metadataAction := GtRlExportReleaseMetadataAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: metadataAction.
		
	commitAction := GtRlCommitAndTagReleaseAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: commitAction
]
