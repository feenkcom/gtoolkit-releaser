Class {
	#name : 'GtRlSystemRepositoriesExplorer',
	#superclass : 'Object',
	#instVars : [
		'rootProject',
		'icebergRegistry'
	],
	#category : 'GToolkit-Releaser-IcebergExtensions'
}

{ #category : 'instance creation' }
GtRlSystemRepositoriesExplorer class >> forProject: aGtRlProject [ 
	^ self new
		initializeForRootProject: aGtRlProject
]

{ #category : 'ui' }
GtRlSystemRepositoriesExplorer >> gtViewSystemRepositoriesFor: aView [
	<gtView>
	^ self icebergRegistry 
		ifNil:  [ aView ]
		ifNotNil: [ self icebergRegistry  gtRepositoriesListFor: aView ]
]

{ #category : 'accessing' }
GtRlSystemRepositoriesExplorer >> icebergRegistry [
	^ icebergRegistry
]

{ #category : 'initialization' }
GtRlSystemRepositoriesExplorer >> initializeForRootProject: aProject [
	rootProject := aProject.
	icebergRegistry := GtRlIceRegistry new.
	icebergRegistry repositories: (rootProject withAllRepositories collect: #icebergRepository).
]

{ #category : 'accessing' }
GtRlSystemRepositoriesExplorer >> rootProject [
	^ rootProject
]
