Class {
	#name : #GtRlDedicatedBranchReleaseStrategy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#instVars : [
		'referenceBranchName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlDedicatedBranchReleaseStrategy >> description [
	^ 'Branch #', (self releaseBranchName ifNil: [ 'missing' ])
]

{ #category : #ui }
GtRlDedicatedBranchReleaseStrategy >> gtCommitsAncestryFor: aView [
	<gtView>
	self repositoryRelease ifNil: [ ^ aView ].
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
GtRlDedicatedBranchReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		referenceBranchName: aRepositoryRelease icebergRepository branchName;
		releaseBranchName: (aReleaseConfiguration releaseBranchForRepository: aRepositoryRelease repository)
]

{ #category : #'private - testing' }
GtRlDedicatedBranchReleaseStrategy >> isReferenceBranchMergedIn: anIceCommit [
	| latestRefenceBranchCommit |
	latestRefenceBranchCommit := self referenceBranch commit.
	^ anIceCommit isParentOf: latestRefenceBranchCommit
]

{ #category : #actions }
GtRlDedicatedBranchReleaseStrategy >> mergeToReleaseBranch [
	| icebergRepository |
	icebergRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName
]

{ #category : #'accessing - dynamic' }
GtRlDedicatedBranchReleaseStrategy >> referenceBranch [
	^ self repositoryRelease icebergRepository branchNamed: self referenceBranchName 
]

{ #category : #accessing }
GtRlDedicatedBranchReleaseStrategy >> referenceBranchName [
	^ referenceBranchName
]

{ #category : #accessing }
GtRlDedicatedBranchReleaseStrategy >> referenceBranchName: aBranchName [
	referenceBranchName := aBranchName
]

{ #category : #'private - testing' }
GtRlDedicatedBranchReleaseStrategy >> shouldCreateNewRelease [
	| latestVersionTag releaseMetadata|
	
	"1. If a new release if explicitly requested created it."
	self shouldForceNewRelease ifTrue: [ 
		^ true ].
	
	"2. If there is no release tag in the repository a new release is needed."
	self repositoryRelease semanticVersionTags ifEmpty: [
		^ true ].
	
	"3. If the latest release tag does not include the latest commit from the reference branch generate a new release."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	(self isReferenceBranchMergedIn: latestVersionTag commit) ifFalse: [
		^ true ].
	
	"4. If any dependency has a different version than in the current release generate a new release."
	releaseMetadata := GtRlReleaseVersionMetadata fromCommit: latestVersionTag commit.
	(self repositoryRelease matchesDependenciesIn: releaseMetadata) ifFalse: [
		^ true ].
	
	^ false
]

{ #category : #actions }
GtRlDedicatedBranchReleaseStrategy >> updateFor: anUpdateWorkflow [
	| latestVersionTag |
	
	self shouldCreateNewRelease ifTrue: [ 
		^ self configureNewVersionRelease ].
	
	"If a new release is not requires used the latest semantic tag and make the release passive."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.	
	^ self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber;
		makePassiveRelease
]

{ #category : #'actions - building' }
GtRlDedicatedBranchReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	| mergeAction commitAction metadataAction |
	self repositoryRelease resetReleaseActions.
	self repositoryRelease isPassiveRelease ifTrue: [ ^ self ].
	
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
	self repositoryRelease addReleaseAction: commitAction.
]
