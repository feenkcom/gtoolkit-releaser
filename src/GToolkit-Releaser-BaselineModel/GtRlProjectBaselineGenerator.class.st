"
A printer that generates the source code of a baseline for a {{gtClass:GtRlProject}} instance.

It used the child projects defined with the project to specify baseline dependencies.
"
Class {
	#name : #GtRlProjectBaselineGenerator,
	#superclass : #GtRlBaselineGenerator,
	#instVars : [
		'project'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Generator'
}

{ #category : #'instance creation' }
GtRlProjectBaselineGenerator class >> forProject: aProject [
	^ self new
		project: aProject
]

{ #category : #baselines }
GtRlProjectBaselineGenerator >> baselineProject [
	^ project
]

{ #category : #api }
GtRlProjectBaselineGenerator >> generateProjectDependenciesOn: aStream [
	project childProjects do: [ :aProject |
		aStream 
			projectDependencyFor: aProject name
			withLoadSpec: aProject repository loadSpecificationString ].
]

{ #category : #testing }
GtRlProjectBaselineGenerator >> hasProjectDependencies [
	^ project childProjects notEmpty
]

{ #category : #accessing }
GtRlProjectBaselineGenerator >> project: aProject [
	project := aProject
]
