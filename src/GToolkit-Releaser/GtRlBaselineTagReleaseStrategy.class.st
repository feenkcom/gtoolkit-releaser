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
	self repositoryRelease
		version: self tagVersionNumber;
		makePassiveRelease
]
