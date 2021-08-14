Class {
	#name : 'GtRlBaselineVersionReleaseStrategy',
	#superclass : 'GtRlReleaseStrategy',
	#category : 'GToolkit-Releaser'
}

{ #category : 'assertions' }
GtRlBaselineVersionReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	self 
		assert: [ aRepository hasVersion ]
		description: 'The repository should have an explicit version loaded through the baseline'.
	
	self flag: 'Improve this to check for commit hash or tag'
	"self 
		assert: [ aRepository icebergRepository headCommit tags isNotEmpty ]
		description: 'The head commit in the repository should contain a tag, otherwise this strategy is not appropriate'.
	self
		assert: [ 
			| loadedVersion |
			loadedVersion := aRepository versionString.
			aRepository icebergRepository headCommit tags anySatisfy: [ :aTag | 
				aTag name = loadedVersion ] ]
		description: 'The current version loaded in the image should be a tag present in the head commit.'."
]

{ #category : 'printing' }
GtRlBaselineVersionReleaseStrategy >> description [
	^ 'BaselineVersion'
]

{ #category : 'accessing - dynamic' }
GtRlBaselineVersionReleaseStrategy >> loadedVersionNumber [
	^ GtRlBaselineVersionNumber new 
		versionString: self repositoryRelease repository versionString
]

{ #category : 'accessing' }
GtRlBaselineVersionReleaseStrategy >> updateFor: anUpdateWorkflow [
	self flag: 'Improve to check that all repos below this one are passive'.
	"self 
		assert: [ self repositoryRelease withAllChildRepositoryReleases allSatisfy: [ :aRelease |
				aRelease releaseStrategy class = self class ] ] 
		description: 'If a fixed tag is used as a release version all children repositories should use the same loaded tag strategy.'."
		
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self loadedVersionNumber) emit.
	self repositoryRelease
		version: self loadedVersionNumber;
		makePassiveRelease
]
