Class {
	#name : #GtRlLatestCommitReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlLatestCommitReleaseStrategy >> commitVersionNumber [
	^ GtRlCommitIdVersionNumber new
		commitId: self repositoryRelease icebergRepository headCommit id
]

{ #category : #printing }
GtRlLatestCommitReleaseStrategy >> description [
	^ 'LatestCommit'
]

{ #category : #accessing }
GtRlLatestCommitReleaseStrategy >> updateFor: anUpdateWorkflow [
	(GtRlRepositoryReleaseVersionSignal repositoryRelease: self repositoryRelease version: self commitVersionNumber) emit.
	self repositoryRelease
		version: self commitVersionNumber;
		makePassiveRelease
]
