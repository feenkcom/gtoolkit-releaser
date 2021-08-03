Class {
	#name : #GtRlGToolkitRepositoriesExplorer,
	#superclass : #GtRlSystemRepositoriesExplorer,
	#category : 'GToolkit-Releaser-IcebergExtensions'
}

{ #category : #accessing }
GtRlGToolkitRepositoriesExplorer class >> buildForGToolkitProject [
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit:main/src'.
	^ self forProject: project
]

{ #category : #ui }
GtRlGToolkitRepositoriesExplorer >> gtViewAllImageRepositoriesFor: aView [
	<gtView>
	^ (GtRlIceRegistry forAllIcebergRepositories gtRepositoriesListFor: aView)
		title: 'All repositories';
		priority: 25
]

{ #category : #ui }
GtRlGToolkitRepositoriesExplorer >> gtViewGToolkitRepositoriesFor: aView [
	<gtView>
	| gtoolitRegistry |
	self icebergRegistry ifNil: [ ^ aView ].
	gtoolitRegistry := self icebergRegistry select: [ :aRepository | 
		aRepository name beginsWith: 'gtoolkit' ].
	^ (gtoolitRegistry gtRepositoriesListFor: aView)
			title: 'GToolkit' translated;
			priority: 5
]

{ #category : #ui }
GtRlGToolkitRepositoriesExplorer >> gtViewGraphicalStackRepositoriesFor: aView [
	<gtView>
	| graphicalRegistry |
	self icebergRegistry ifNil: [ ^ aView ].
	graphicalRegistry := self icebergRegistry select: [ :aRepository | 
		{ 'brick' . 'bloc' . 'sparta' } anySatisfy: [ :aPrefix |
			aRepository name asLowercase beginsWith: aPrefix ] ].
	^ (graphicalRegistry gtRepositoriesListFor: aView)
			title: 'Brick, Bloc & Sparta' translated;
			priority: 10
]

{ #category : #ui }
GtRlGToolkitRepositoriesExplorer >> gtViewSystemRepositoriesFor: aView [
	<gtView>
	^ (super gtViewSystemRepositoriesFor: aView)
			title: 'GToolkit & Dependencies' translated;
			priority: 15
]
