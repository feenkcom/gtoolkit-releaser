Class {
	#name : #GtRlLoadedTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlLoadedTagReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	self 
		assert: [ aRepository hasVersion ]
		description: 'The repository should have an explicit version loaded through the baseline'.
	self 
		assert: [ aRepository icebergRepository headCommit tags isNotEmpty ]
		description: 'The head commit in the repository should contain a tag, otherwise this strategy is not appropriate'.
	self
		assert: [ 
			| loadedVersion |
			loadedVersion := aRepository versionString.
			aRepository icebergRepository headCommit tags anySatisfy: [ :aTag | 
				aTag name = loadedVersion ] ]
		description: 'The current version loaded in the image should be a tag present in the head commit.'.
]

{ #category : #printing }
GtRlLoadedTagReleaseStrategy >> description [
	^ 'BaselineTag'
]

{ #category : #'accessing - dynamic' }
GtRlLoadedTagReleaseStrategy >> loadedTagVersionNumber [
	^ GtRlTagVersionNumber new 
		tagName: self repositoryRelease repository versionString
]

{ #category : #accessing }
GtRlLoadedTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	self 
		assert: [ self repositoryRelease withChildRepositoryReleases allSatisfy: [ :aRelease |
				aRelease releaseStrategy class = self class ] ] 
		description: 'If a fixed tag is used as a release version all children repositories should use the same loaded tag strategy.'.
		
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self loadedTagVersionNumber) emit.
	self repositoryRelease
		version: self loadedTagVersionNumber;
		makePassiveRelease
]
