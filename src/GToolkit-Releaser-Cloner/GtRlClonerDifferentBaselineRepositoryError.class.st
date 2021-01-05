Class {
	#name : #GtRlClonerDifferentBaselineRepositoryError,
	#superclass : #GtRlClonerBaselineError,
	#instVars : [
		'loadedProject'
	],
	#category : #'GToolkit-Releaser-Cloner-Errors'
}

{ #category : #accessing }
GtRlClonerDifferentBaselineRepositoryError >> defaultMessageText [
	'Different repository location for baseline {1} detected! The baseline was already loaded from {2}, and a new load attempt from {3} was attempted. Update the baselines to only use one repository location.' format: { 
		self baselineName.
		self loadedRepositoryLocation.
		self repositoryLocation  }
]

{ #category : #accessing }
GtRlClonerDifferentBaselineRepositoryError >> loadedProject [
	^ loadedProject
]

{ #category : #accessing }
GtRlClonerDifferentBaselineRepositoryError >> loadedProject: anObject [
	loadedProject := anObject
]

{ #category : #accessing }
GtRlClonerDifferentBaselineRepositoryError >> loadedRepositoryLocation [
	^ self loadedProject repository urlString
]
