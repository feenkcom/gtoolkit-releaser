"
I model a package requirement in a baseline.

The source node of the dependency is the package. The target is another type of ${class:GtRlNode}$ from the baseline. Currently only dependencies to other packages or projects are supported.
"
Class {
	#name : #GtRlPackageDependency,
	#superclass : #Object,
	#instVars : [
		'sourceNode',
		'targetNode'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #printing }
GtRlPackageDependency >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self sourceNode name;
		nextPutAll: ', ';
		nextPutAll: self targetNode name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlPackageDependency >> sourceNode [
	^ sourceNode
]

{ #category : #accessing }
GtRlPackageDependency >> sourceNode: anObject [
	sourceNode := anObject
]

{ #category : #accessing }
GtRlPackageDependency >> targetNode [
	^ targetNode
]

{ #category : #accessing }
GtRlPackageDependency >> targetNode: anObject [
	targetNode := anObject
]
