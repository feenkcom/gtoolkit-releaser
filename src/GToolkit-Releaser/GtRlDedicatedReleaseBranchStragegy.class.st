Class {
	#name : #GtRlDedicatedReleaseBranchStragegy,
	#superclass : #GtRlReleaseStragegy,
	#instVars : [
		'referenceBranchName',
		'releaseBranchName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #actions }
GtRlDedicatedReleaseBranchStragegy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #ui }
GtRlDedicatedReleaseBranchStragegy >> gtCommitsAncestryFor: aView [
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

{ #category : #actions }
GtRlDedicatedReleaseBranchStragegy >> mergeToReleaseBranch [
	| icebergRepository |
	icebergRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName
]

{ #category : #'accessing - dynamic' }
GtRlDedicatedReleaseBranchStragegy >> referenceBranch [
	^ self repositoryRelease icebergRepository branchNamed: self referenceBranchName 
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> referenceBranchName [
	^ referenceBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> referenceBranchName: aBranchName [
	referenceBranchName := aBranchName
]

{ #category : #'accessing - dynamic' }
GtRlDedicatedReleaseBranchStragegy >> releaseBranch [
	^ self repositoryRelease icebergRepository branchNamed: self releaseBranchName 
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> releaseBranchName [
	^ releaseBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> releaseBranchName: aBranchName [
	releaseBranchName := aBranchName
]

{ #category : #'accessing - dynamic' }
GtRlDedicatedReleaseBranchStragegy >> releaseTarget [
	^ '#', self releaseBranchName
]
