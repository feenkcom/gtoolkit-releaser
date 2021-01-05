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

{ #category : #accessing }
GtRlClonerBaselineSpec >> repositoryLocation [
	^ repositoryLocation
]

{ #category : #accessing }
GtRlClonerBaselineSpec >> repositoryLocation: anObject [
	repositoryLocation := anObject
]
