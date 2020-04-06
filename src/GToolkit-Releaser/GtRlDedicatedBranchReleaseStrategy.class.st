"
I am a release strategy that uses a dedicated release branch for creating the release.

To perform the release I generate actions for: 
	- checking out the release branch and merging the current branch into the release branch;
	- compiling updated Monticelo baselines for the project releases contained in the repository that point to the version numbers of those project releases; 
	- exporting metatada containing the version numbers used for each child repository;
	- make a new commit on the release branch and tag it with the version number of this release;
	- push the commit to origin, if a remote origin can be found.
	
See ${method:GtRlDedicatedBranchReleaseStrategy>>#shouldCreateNewRelease}$ for the cases when I generate a new release.
"
Class {
	#name : #GtRlDedicatedBranchReleaseStrategy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#instVars : [
		'referenceBranchName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlDedicatedBranchReleaseStrategy >> assertBaselineMethodNodeFor: aNode [
	self assert: aNode value definition isMethodDefinition.
	self assert: aNode value isModification.
	self assert: aNode parent value hasChanges not.
	self assert: aNode parent value definition isClassDefinition.
	self assert: aNode parent value definition isMeta not.
	self assert: (aNode parent value definition name matchesRegex: 'BaselineOf.+').
]

{ #category : #assertions }
GtRlDedicatedBranchReleaseStrategy >> assertOnlyAllowedChanges [
	| referenceCommit releaseCommit |
	
	referenceCommit := self referenceBranch commit.
	releaseCommit := self releaseBranch commit.

	self assertOnlyAllowedChangesBetween: referenceCommit and: releaseCommit.
]

{ #category : #assertions }
GtRlDedicatedBranchReleaseStrategy >> assertOnlyAllowedChangesBetween: aSourceCommit and: aTargetCommit [
	| commonAncestor sourceDiff targetDiff releaserChanges metadataChanges |
	commonAncestor := (aSourceCommit commonAncestorWith: aTargetCommit).
	sourceDiff := aSourceCommit diffTo: commonAncestor.
	targetDiff := aTargetCommit diffTo: commonAncestor.

	self assert: sourceDiff isEmpty description:'sourceDiff isEmpty'.
	releaserChanges := OrderedCollection new.
	targetDiff tree isEmptyNode ifFalse: [ 
		targetDiff tree allChildrenDo: [ :e |
			(e isEmptyNode not and: [ e value hasChanges ]) ifTrue: [ 
				releaserChanges add: e ] ] ].
	
	
	releaserChanges do: [ :aChange | NonInteractiveTranscript stdout show: aChange ].
	
	self assert: (releaserChanges allSatisfy: [ :aNode |
		aNode key = GtRlReleaseVersionMetadata fileName or: [ 
			aNode key = 'baseline:' ] ]) description: 'releaserChanges allSatisfy'.
	releaserChanges 
		select: [ :aNode | aNode key = 'baseline:' ] 
		thenDo: [ :aNode | self assertBaselineMethodNodeFor: aNode ].
	metadataChanges := releaserChanges 
		select: [ :aNode | aNode key = GtRlReleaseVersionMetadata fileName ].
	self assert: metadataChanges size <= 1 description: 'metadataChanges size <= 1'.
	metadataChanges do: [ :aNode |
		self assert: (aNode value definition isFileDefinition) description: '(aNode value definition isFileDefinition)' ]
]

{ #category : #printing }
GtRlDedicatedBranchReleaseStrategy >> description [
	^ 'Branch ', (self releaseBranchName 
		ifNil: [ '<missing>' ]
		ifNotNil: [ :branchName | '#', branchName  ])
]

{ #category : #testing }
GtRlDedicatedBranchReleaseStrategy >> findNewCommits [
	|repoRelease releaseCommit lastMergedCommit result walk repo masterCommit|
	repoRelease := self  repositoryRelease.
	repo := repoRelease icebergRepository.
	result := GtRlNewCommits new.
	result repository: repo.
	
	repo remoteNamed: 'origin' ifAbsent:[ ^ result ].
	masterCommit := (repo 
		branchNamed: 'master'	
		ifAbsent: [ repo createBranch: 'master' ]) commit.
	releaseCommit := ((repo remoteNamed: 'origin') 
		remoteBranchNamed: 'release' 
		ifPresent: [ :branch |  branch commit] 
		ifAbsent: [ ^ result ]).
	
	"on the release branch we may have a string of release commits"
	"we need to find the one right after the merge"
	[
		(releaseCommit ancestors size == 1) and: [
			(releaseCommit tags anySatisfy: [ :anIceTag | 'v0.*' match: anIceTag name]) and: [
				(masterCommit = releaseCommit parent) not] ]
	] whileTrue: [ releaseCommit := releaseCommit parent ].

	lastMergedCommit := releaseCommit ancestors 
		detect: [ :commit | commit tags 
			detect: [ :anIceTag | 'v0.*' match: anIceTag name ] 
			ifFound: [false] 
			ifNone: [true] ]
		ifNone: [ 
			"This could happen in case the ancestor from the main branch also contains a release tag.
			In that case both ancestors will have a release tag. 
			If that happens do not try to compute the changed commits "
			^ result ].

	walk := IceLibgitCommitWalk new.
	walk repository: repoRelease icebergRepository.
	walk 
		fromBranch: (repo branchNamed: 'master'	ifAbsent: [	repo createBranch: 'master' ]); 
		uptoCommit: lastMergedCommit.
	walk commitsDo: [ :c | result addCommit: c ].
	
	^ result

	
	
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
			commitsReleaseBranch := Set new.
			self releaseBranch ifNotNil: 
				[commitsReleaseBranch :=  self releaseBranch commits].
			
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
	icebergRepository isModified ifTrue: [ 
		"Attemp here to make the repository clean. Sometimes repository are marked as dirty even if
		they have no changes."
		icebergRepository workingCopy forceCalculateDirtyPackages ].
	
	"Hacky tachy way of ensuring the repo is clean."
	icebergRepository isModified ifTrue: [ 
		
		"Attemp here to make the repository clean. Sometimes repository are marked as dirty even if
		they have no changes."
		icebergRepository workingCopy forceCalculateDirtyPackages ].
	
	self 
		assert: [ icebergRepository isModified not ]
		description: 'There should be no changes in the repository when switching to the release branch.'.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName.
	
	"Baselines and the metadata file can appear as changed as we do not update the code in the image."
	self assertOnlyAllowedChanges
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

{ #category : #testing }
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
