Class {
	#name : #GtRlMetacelloProjectBaselineGenerator,
	#superclass : #GtRlMetacelloBaselineGenerator,
	#instVars : [
		'project'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Metacello'
}

{ #category : #'instance creation' }
GtRlMetacelloProjectBaselineGenerator class >> forProject: aProject [
	^ self new
		project: aProject
]

{ #category : #baselines }
GtRlMetacelloProjectBaselineGenerator >> baselineProject [
	^ project
]

{ #category : #'accessing - dynamic' }
GtRlMetacelloProjectBaselineGenerator >> childProjectsWithRepositoryURL [
	^ project childProjects collect: [ :aProject |
		aProject name -> {aProject repository loadSpecificationString} ]
]

{ #category : #accessing }
GtRlMetacelloProjectBaselineGenerator >> project: aProject [
	project := aProject
]
