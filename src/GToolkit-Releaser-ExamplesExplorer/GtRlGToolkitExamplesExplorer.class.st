Class {
	#name : #GtRlGToolkitExamplesExplorer,
	#superclass : #GtRlSystemExamplesExplorer,
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlGToolkitExamplesExplorer class >> buildForGToolkitProject [
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit:main/src'.
	^ self forProject: project
]

{ #category : #ui }
GtRlGToolkitExamplesExplorer >> gtViewBrickStackRepositoriesListFor: aView [
	<gtView>
	^ (super gtViewRepositoriesListFor: aView)
		title: 'Brick, bloc & sparta' translated;
		priority: 10;
		items: [ self repositoryExplorers select: [ :aRepositoryExported | 
			| repositoryName |
			repositoryName := aRepositoryExported repository repositoryName asLowercase.
			{ 'brick' . 'bloc' . 'sparta' } anySatisfy: [ :aPrefix |
				repositoryName beginsWith: aPrefix ] ] ]
]

{ #category : #ui }
GtRlGToolkitExamplesExplorer >> gtViewGtoolkitRepositoriesListFor: aView [
	<gtView>
	^ (super gtViewRepositoriesListFor: aView)
		title: 'GToolkit' translated;
		priority: 5;
		items: [ self repositoryExplorers select: [ :aRepositoryExported | 
				aRepositoryExported repository repositoryName beginsWith: 'gtoolkit' ] ]
]

{ #category : #ui }
GtRlGToolkitExamplesExplorer >> gtViewRepositoriesListFor: aView [
	<gtView>
	^ (super gtViewRepositoriesListFor: aView)
		title: 'GToolkit & dependencies' translated;
		priority: 15
]
