"
I am a release strategy that uses the current loaded tag for a repository as the version number.

I indicate a passive release as no actions need to be executed. The version number already exists in the repository.
I should only be used for repositories that have no child repositories or when all child repositories also use this strategy, as I hardcode an existing tag.
As I am passive I do not export any metadata. Even if the repository has child repositories there will be no metadata exported. Because of this I do not use metadata to check previous versions (it is not reliable).

I am a valid release strategy only when all Monticello baselines that load this project use the same tag to load it. 
See ${method:GtRlBaselineTagReleaseStrategy>>#assertCompatibleWithRepository:}$ for assertions that check when I can be used.
"
Class {
	#name : #GtRlBaselineTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlBaselineTagReleaseStrategy >> assertCompatibleWithRepository: aRepository [
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
GtRlBaselineTagReleaseStrategy >> description [
	^ 'BaselineTag'
]

{ #category : #'accessing - dynamic' }
GtRlBaselineTagReleaseStrategy >> loadedTagVersionNumber [
	^ GtRlTagVersionNumber new 
		tagName: self repositoryRelease repository versionString
]

{ #category : #accessing }
GtRlBaselineTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	self 
		assert: [ self repositoryRelease withAllChildRepositoryReleases allSatisfy: [ :aRelease |
				aRelease releaseStrategy class = self class ] ] 
		description: 'If a fixed tag is used as a release version all children repositories should use the same loaded tag strategy.'.
		
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self loadedTagVersionNumber) emit.
	self repositoryRelease
		version: self loadedTagVersionNumber;
		makePassiveRelease
]
