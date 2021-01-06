Class {
	#name : #GtRlClonerBaselineSpec,
	#superclass : #Object,
	#instVars : [
		'baselineName',
		'repositoryLocation'
	],
	#category : #'GToolkit-Releaser-Cloner-Core'
}

{ #category : #accessing }
GtRlClonerBaselineSpec >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineSpec >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #printing }
GtRlClonerBaselineSpec >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: (self baselineName ifNil: [ '<missing>' ]);
		nextPutAll: ', ';
		nextPutAll: (self repositoryLocation ifNil: [ '<missing>' ]);
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlClonerBaselineSpec >> repositoryLocation [
	^ repositoryLocation
]

{ #category : #accessing }
GtRlClonerBaselineSpec >> repositoryLocation: anObject [
	repositoryLocation := anObject
]
