Class {
	#name : #GtRlClonerDifferentRepositoryVersionError,
	#superclass : #GtRlClonerBaselineError,
	#instVars : [
		'loadedVersionString',
		'newVersionString'
	],
	#category : #'GToolkit-Releaser-Cloner-Errors'
}

{ #category : #accessing }
GtRlClonerDifferentRepositoryVersionError >> defaultMessageText [
	'Different versions for baseline of project {1} detected! Loaded version: {2}; new version: {3}. Update the baselines to only use one version.' format: { 
		self baselineName.
		self loadedVersionString.
		self newVersionString }
]

{ #category : #accessing }
GtRlClonerDifferentRepositoryVersionError >> loadedVersionString [
	^ loadedVersionString
]

{ #category : #accessing }
GtRlClonerDifferentRepositoryVersionError >> loadedVersionString: anObject [
	loadedVersionString := anObject
]

{ #category : #accessing }
GtRlClonerDifferentRepositoryVersionError >> newVersionString [
	^ newVersionString
]

{ #category : #accessing }
GtRlClonerDifferentRepositoryVersionError >> newVersionString: anObject [
	newVersionString := anObject
]
