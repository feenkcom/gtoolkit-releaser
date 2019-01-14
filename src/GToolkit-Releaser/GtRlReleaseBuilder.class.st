"
I am responsible with creating a new release model from a baseline model following a given configuration.

My main API method for creating the release model is ${method:GtRlReleaseBuilder>>#buildReleaseForProject:}$.
To create the release I use two other classes:
	- ${class:GtRlReleaseStructureBuilder}$ - builds the structure of release from a baseline model;
	- ${class:GtRlReleaseUpdateWorkflow}$ - updates the version number and strategy for releases based on the given configuration.
"
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
	self updateWorkflow updateProject: projectRelease.
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
