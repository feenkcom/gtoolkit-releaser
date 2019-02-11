Class {
	#name : #GtRlGToolkitDocumentationExplorer,
	#superclass : #GtRlSystemDocumentationExplorer,
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlGToolkitDocumentationExplorer class >> buildForGToolkitProject [
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit/src'.
	^ self forProject: project
]
