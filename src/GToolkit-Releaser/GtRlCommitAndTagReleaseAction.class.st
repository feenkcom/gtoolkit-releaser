Class {
	#name : #GtRlCommitAndTagReleaseAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> description [
	^ 'Commit changes on current branch and tag commit with ',
		'''', self repositoryRelease versionString,''''
]

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> descriptionDetails [
	^ 'commit and tag with ', self repositoryRelease versionString
]

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> name [
	^ 'Commit and tag release'
]

{ #category : #actions }
GtRlCommitAndTagReleaseAction >> performAction [
	self releaseStrategy commitAndTagRelease
]
