Class {
	#name : #GtRlLoadedTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlLoadedTagReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	"We only require that the current loaded version of the project has a tag, 
	that we will use when generating a release for this repository. The project can
	then be loaded either by spcifyinf an explicit tag or loading a branch that has a tag."
	
	self 
		assert: [ aRepository icebergRepository headCommit tags isNotEmpty ]
		description: 'The head commit in the repository should contain a tag, otherwise this strategy is not appropriate'.
		
	"Do not allow multiple tags in the loaded commit. Otherwise, we cannot determine which is the release."
	self
		assert: [ aRepository icebergRepository headCommit tags size = 1 ]
		description: 'The current loaded commit should just have a single tag'.
]

{ #category : #'accessing - dynamic' }
GtRlLoadedTagReleaseStrategy >> currentTagVersionNumber [
	^ self repositoryRelease icebergRepository headCommit tags first name
]

{ #category : #printing }
GtRlLoadedTagReleaseStrategy >> description [
	^ 'LoadedTag'
]

{ #category : #accessing }
GtRlLoadedTagReleaseStrategy >> updateFor: anUpdateWorkflow [

	self flag: 'Add assertions to check that all the subprojects '.
	"self 
		assert: [ self repositoryRelease withAllChildRepositoryReleases allSatisfy: [ :aRelease |
				aRelease releaseStrategy class = self class ] ] 
		description: 'If a fixed tag is used as a release version all children repositories should use the same loaded tag strategy.'."
	
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self currentTagVersionNumber) emit.
	self repositoryRelease
		version: self currentTagVersionNumber;
		makePassiveRelease
]
