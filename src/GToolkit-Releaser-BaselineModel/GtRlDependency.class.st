Class {
	#name : #GtRlDependency,
	#superclass : #Object,
	#instVars : [
		'sourceNode',
		'targetNode'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #printing }
GtRlDependency >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self sourceNode name;
		nextPutAll: ', ';
		nextPutAll: self targetNode name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlDependency >> sourceNode [
	^ sourceNode
]

{ #category : #accessing }
GtRlDependency >> sourceNode: anObject [
	sourceNode := anObject
]

{ #category : #accessing }
GtRlDependency >> targetNode [
	^ targetNode
]

{ #category : #accessing }
GtRlDependency >> targetNode: anObject [
	targetNode := anObject
]
