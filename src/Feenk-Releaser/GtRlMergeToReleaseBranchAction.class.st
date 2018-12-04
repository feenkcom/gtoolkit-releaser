Class {
	#name : #GtRlMergeToReleaseBranchAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'Feenk-Releaser'
}

{ #category : #printing }
GtRlMergeToReleaseBranchAction >> description [
	^ 'Merge reference branch ',
		'#', self repositoryRelease releaseStrategy referenceBranchName,
		' to release branch ',
		'#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
GtRlMergeToReleaseBranchAction >> descriptionDetails [
	^
		'#', self repositoryRelease releaseStrategy referenceBranchName,
		' --> ',
		'#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
GtRlMergeToReleaseBranchAction >> name [ 
	^ 'Merge to release branch'
]

{ #category : #actions }
GtRlMergeToReleaseBranchAction >> performAction [
	self releaseStrategy mergeToReleaseBranch
]
