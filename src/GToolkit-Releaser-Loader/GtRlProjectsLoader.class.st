Class {
	#name : #GtRlProjectsLoader,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Loader-Core'
}

{ #category : #actions }
GtRlProjectsLoader >> cloneBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| projectCloner |
	projectCloner := GtRlProjectsCloner new.
	projectCloner 
		baseline: aBaselineName;
		repository: aRepositoryLocationString.
	^ projectCloner execute
]

{ #category : #actions }
GtRlProjectsLoader >> loadBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| clonedProject |
	clonedProject := self 
		cloneBaseline: aBaselineName 
		fromRepository: aRepositoryLocationString.
	self 
		loadBaselineClass: clonedProject baselineClass
		fromRepository: clonedProject repository urlString
]

{ #category : #actions }
GtRlProjectsLoader >> loadBaselineClass: aBaselineClass fromRepository: aRepositoryLocationString [
	| rootProject |
	rootProject := aBaselineClass
		gtRlProjectWithRepository: aRepositoryLocationString.
	
	self loadFullProject: rootProject
]

{ #category : #actions }
GtRlProjectsLoader >> loadFullProject: aRootProject [
	| structureBuilder loadDirective loadWorkflow |
	structureBuilder := GtRlLoadDirectiveStructureBuilder new.
	loadDirective := structureBuilder 
		buildLoadDirectiveForProject: aRootProject.
	
	loadWorkflow := GtRlProjectsLoadWorkflow new
		rootLoadDirective: loadDirective.
	loadWorkflow executeLoadActions
]
