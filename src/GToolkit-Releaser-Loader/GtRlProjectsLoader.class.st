Class {
	#name : #GtRlProjectsLoader,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #'as yet unclassified' }
GtRlProjectsLoader >> loadFullProject2: aRootProject [
	| projectsInLoadOrder |
	projectsInLoadOrder := GtRlLoadDirectivesOrderTraversal new
		loadOrderFor: aRootProject.
	projectsInLoadOrder do: [ :aProject | 
		self loadProject: aProject ]
]

{ #category : #'as yet unclassified' }
GtRlProjectsLoader >> loadFullProject: aRootProject [
	| structureBuilder loadDirective loadWorkflow |
	structureBuilder := GtRlLoadDirectiveStructureBuilder new.
	loadDirective := structureBuilder 
		buildLoadDirectiveForProject: aRootProject.
	
	loadWorkflow := GtRlProjectsLoadWorkflow new
		rootLoadDirective: loadDirective.
	loadWorkflow executeLoadActions
]

{ #category : #'as yet unclassified' }
GtRlProjectsLoader >> loadProject: aProject [
	| rootPackages |
	rootPackages := aProject rootPackages.
]
