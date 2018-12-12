Class {
	#name : #GtRlReleaseBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlReleaseBuilder class >> forConfiguration: aReleaseConfiguration [
	^ self new
		configuration: aReleaseConfiguration
]

{ #category : #building }
GtRlReleaseBuilder >> buildReleaseForProject: aProject [
	| projectRelease |
	projectRelease := self structureBuilder buildStructureForProject: aProject.
	self updateWorkflow update: projectRelease.
	^ projectRelease 
]

{ #category : #accessing }
GtRlReleaseBuilder >> configuration [
	^ configuration
]

{ #category : #accessing }
GtRlReleaseBuilder >> configuration: aReleaseConfiguration [
	configuration := aReleaseConfiguration
]

{ #category : #'accessing - dynamic' }
GtRlReleaseBuilder >> structureBuilder [
	^ GtRlReleaseStructureBuilder forConfiguration: self configuration
]

{ #category : #'accessing - dynamic' }
GtRlReleaseBuilder >> updateWorkflow [
	^ GtRlReleaseUpdateWorkflow new
]
