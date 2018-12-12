Class {
	#name : #GtRlNullReleaseStragegy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlNullReleaseStragegy >> nullVersionNumber [
	^ GtRlNullVersionNumber new
]

{ #category : #actions }
GtRlNullReleaseStragegy >> updateFor: anUpdateWorkflow [
	self repositoryRelease
		version: self nullVersionNumber;
		resetReleaseActions
]
