"
A printer that generates the source code of a baseline for a {{gtClass:GtRlProject}} instance.

It used the child projects defined with the project to specify baseline dependencies.
"
Class {
	#name : #GtRlProjectBaselinePrinter,
	#superclass : #GtRlBaselinePrinter,
	#instVars : [
		'project'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Printer'
}

{ #category : #'instance creation' }
GtRlProjectBaselinePrinter class >> forProject: aProject [
	^ self new
		project: aProject
]

{ #category : #baselines }
GtRlProjectBaselinePrinter >> baselineProject [
	^ project
]

{ #category : #api }
GtRlProjectBaselinePrinter >> generateProjectDependenciesOn: aStream [
	project childProjects do: [ :aProject |
		aStream 
			projectDependencyFor: aProject name
			withLoadSpec: aProject repository loadSpecificationString ].
]

{ #category : #testing }
GtRlProjectBaselinePrinter >> hasProjectDependencies [
	^ project childProjects notEmpty
]

{ #category : #accessing }
GtRlProjectBaselinePrinter >> project: aProject [
	project := aProject
]
