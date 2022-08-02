"
I merge the reference branch to the release branch.

I only work with strategies of type {{gtClass:GtRlSemanticTagReleaseStrategy}}. 
"
Class {
	#name : #GtRlMergeToReleaseBranchAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'GToolkit-Releaser'
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
