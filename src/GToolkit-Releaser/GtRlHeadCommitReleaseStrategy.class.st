"
I am a release strategy that uses the id of the head commit as the version number.

I indicate a passive release as no actions need to be executed. The version number already exists in the repository.
I should only be used for repositories that have no child repositories as I hardcode an existing commit. 
As I am passive I do not export any metadata.  

See ${method:GtRlHeadCommitReleaseStrategy>>#assertCompatibleWithRepository:}$ for assertions that check when I can be used.
"
Class {
	#name : #GtRlHeadCommitReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlHeadCommitReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	self 
		assert: [ aRepository childRepositories isEmpty ] 
		description: 'The commit id can be used as a release version only for repositories that do not have any children'.
]

{ #category : #accessing }
GtRlHeadCommitReleaseStrategy >> commitVersionNumber [
	^ GtRlCommitIdVersionNumber new
		commitId: self repositoryRelease icebergRepository headCommit id
]

{ #category : #printing }
GtRlHeadCommitReleaseStrategy >> description [
	^ 'HeadCommit'
]

{ #category : #accessing }
GtRlHeadCommitReleaseStrategy >> updateFor: anUpdateWorkflow [
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self commitVersionNumber) emit.
	self repositoryRelease
		version: self commitVersionNumber;
		makePassiveRelease
]
