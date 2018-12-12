Class {
	#name : #GtRlBaselineTagReleaseStrategy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'GToolkit-Releaser'
}

{ #category : #'accessing - dynamic' }
GtRlBaselineTagReleaseStrategy >> tagVersionNumber [
	^ GtRlTagVersionNumber new 
		tagName: self repositoryRelease icebergRepository headCommit tags first name
]

{ #category : #accessing }
GtRlBaselineTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	self repositoryRelease
		version: self tagVersionNumber;
		resetReleaseActions
]
