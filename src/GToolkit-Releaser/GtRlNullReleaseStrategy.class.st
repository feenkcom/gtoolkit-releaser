"
I provide a null strategy to indicate that a release has no strategy. I mark a release as passive and set {{gtClass:GtRlNullVersionNumber}} as its version number.


"
Class {
	#name : #GtRlNullReleaseStrategy,
	#superclass : #GtRlReleaseStrategy,
	#category : 'GToolkit-Releaser'
}

{ #category : #printing }
GtRlNullReleaseStrategy >> description [
	^ 'null'
]

{ #category : #testing }
GtRlNullReleaseStrategy >> isNullReleaseStrategy [
	^ true
]

{ #category : #accessing }
GtRlNullReleaseStrategy >> nullVersionNumber [
	^ GtRlNullVersionNumber new
]

{ #category : #actions }
GtRlNullReleaseStrategy >> updateFor: anUpdateWorkflow [
	(GtRlRepositoryPassiveReleaseVersionSignal repositoryRelease: self repositoryRelease version: self nullVersionNumber) emit.
	self repositoryRelease
		version: self nullVersionNumber;
		makePassiveRelease
]
