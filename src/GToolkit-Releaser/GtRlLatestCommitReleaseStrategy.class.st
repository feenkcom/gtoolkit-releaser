Class {
	#name : #GtRlLatestCommitReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlLatestCommitReleaseStrategy >> assertCompatibleWithRepository: aRepositoryRelease [
	self 
		assert: [ aRepositoryRelease childRepositories isEmpty ] 
		description: 'The commit id can be used as a release version only for repositories that do not have any children'.
]

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
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self commitVersionNumber) emit.
	self repositoryRelease
		version: self commitVersionNumber;
		makePassiveRelease
]
