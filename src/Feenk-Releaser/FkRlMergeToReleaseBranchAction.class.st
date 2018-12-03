Class {
	#name : #FkRlMergeToReleaseBranchAction,
	#superclass : #FkRlRepositoryReleaseAction,
	#category : #'Feenk-Releaser'
}

{ #category : #printing }
FkRlMergeToReleaseBranchAction >> description [
	^ 'Merge reference branch ',
		'#', self repositoryRelease releaseStrategy referenceBranchName,
		' to release branch ',
		'#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
FkRlMergeToReleaseBranchAction >> descriptionDetails [
	^
		'#', self repositoryRelease releaseStrategy referenceBranchName,
		' --> ',
		'#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
FkRlMergeToReleaseBranchAction >> name [ 
	^ 'Merge to release branch'
]

{ #category : #actions }
FkRlMergeToReleaseBranchAction >> performAction [
	self releaseStrategy mergeToReleaseBranch
]
