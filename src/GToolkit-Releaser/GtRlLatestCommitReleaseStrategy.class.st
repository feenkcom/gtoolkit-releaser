Class {
	#name : #GtRlLatestCommitReleaseStrategy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlLatestCommitReleaseStrategy >> commitVersionNumber [
	^ GtRlCommitIdVersionNumber new
		commitId: self repositoryRelease icebergRepository headCommit id
]

{ #category : #accessing }
GtRlLatestCommitReleaseStrategy >> updateFor: anUpdateWorkflow [
	self repositoryRelease
		version: self commitVersionNumber;
		resetReleaseActions
]
