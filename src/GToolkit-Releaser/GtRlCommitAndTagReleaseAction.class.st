Class {
	#name : #GtRlCommitAndTagReleaseAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> description [
	^ 'Commit changes on branch ',
		'#',self repositoryRelease releaseStrategy releaseBranchName,
		' and tag commit with ',
		'''', self repositoryRelease versionString,''''
]

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> descriptionDetails [
	^ '#',self repositoryRelease releaseStrategy releaseBranchName,
		'[', self repositoryRelease versionString,']'
]

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> name [
	^ 'Commit and tag release'
]

{ #category : #actions }
GtRlCommitAndTagReleaseAction >> performAction [
	self releaseStrategy commitAndTagRelease
]
