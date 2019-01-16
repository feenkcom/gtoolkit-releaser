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
		tagName: self repositoryRelease icebergRepository tags last name
]

{ #category : #accessing }
GtRlBaselineTagReleaseStrategy >> updateFor: anUpdateWorkflow [
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self tagVersionNumber) emit.
	self repositoryRelease
		version: self tagVersionNumber;
		makePassiveRelease
]
