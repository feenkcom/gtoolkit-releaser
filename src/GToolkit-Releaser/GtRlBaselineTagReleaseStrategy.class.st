Class {
	#name : #GtRlBaselineTagReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlBaselineTagReleaseStrategy >> description [
	^ 'BaselineTag'
]

{ #category : #'accessing - dynamic' }
GtRlBaselineTagReleaseStrategy >> tagVersionNumber [
	^ GtRlTagVersionNumber new 
		tagName: self repositoryRelease icebergRepository headCommit tags first name
]

{ #category : #accessing }
GtRlBaselineTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	(GtRlRepositoryReleaseVersionSignal repositoryRelease: self repositoryRelease version: self tagVersionNumber) emit.
	self repositoryRelease
		version: self tagVersionNumber;
		makePassiveRelease
]
