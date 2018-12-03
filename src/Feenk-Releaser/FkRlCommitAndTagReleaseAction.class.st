Class {
	#name : #FkRlCommitAndTagReleaseAction,
	#superclass : #FkRlRepositoryReleaseAction,
	#category : #'Feenk-Releaser'
}

{ #category : #printing }
FkRlCommitAndTagReleaseAction >> description [
	^ 'Commit changes on branch ',
		'#',self repositoryRelease releaseStrategy releaseBranchName,
		' and tag commit with ',
		'''', self repositoryRelease versionString,''''
]

{ #category : #printing }
FkRlCommitAndTagReleaseAction >> descriptionDetails [
	^ '#',self repositoryRelease releaseStrategy releaseBranchName,
		'[', self repositoryRelease versionString,']'
]

{ #category : #printing }
FkRlCommitAndTagReleaseAction >> name [
	^ 'Commit and tag release'
]

{ #category : #actions }
FkRlCommitAndTagReleaseAction >> performAction [
	self releaseStrategy commitAndTagRelease
]
