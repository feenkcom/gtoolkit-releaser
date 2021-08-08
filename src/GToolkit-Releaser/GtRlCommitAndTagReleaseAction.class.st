"
I execute a commit of the current changes staged for commit and push a tag corresponding to the version number of the repository release.

I only work with strategies of type {{gtClass:GtRlSemanticTagReleaseStrategy}}. 
See ${method:GtRlSemanticTagReleaseStrategy>>#commitAndTagRelease} for more implementation details.


"
Class {
	#name : #GtRlCommitAndTagReleaseAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : 'GToolkit-Releaser'
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
	^ 
		'#',self repositoryRelease releaseStrategy releaseBranchName,
		' [', self repositoryRelease versionString,']'
]

{ #category : #ui }
GtRlCommitAndTagReleaseAction >> gtViewCommitMessageFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Commit message' translated;
		text: [ self releaseStrategy repositoryRelease commitMessageForRelease ]
]

{ #category : #printing }
GtRlCommitAndTagReleaseAction >> name [
	^ 'Commit and tag release'
]

{ #category : #actions }
GtRlCommitAndTagReleaseAction >> performAction [
	self releaseStrategy commitAndTagRelease
]
