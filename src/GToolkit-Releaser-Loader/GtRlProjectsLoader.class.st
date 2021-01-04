Class {
	#name : #GtRlProjectsLoader,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #actions }
GtRlProjectsLoader >> cloneBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| projectCloner |
	projectCloner := GtRlProjectsCloneWorkflow new.
	^ projectCloner 
		loadBaseline: aBaselineName 
		fromRepository: aRepositoryLocationString.
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
