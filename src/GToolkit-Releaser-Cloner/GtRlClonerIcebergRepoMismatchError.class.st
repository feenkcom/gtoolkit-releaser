Class {
	#name : #GtRlClonerIcebergRepoMismatchError,
	#superclass : #GtRlClonerBaselineError,
	#instVars : [
		'mismatchType',
		'baselineData',
		'icebergData'
	],
	#category : #'GToolkit-Releaser-Cloner-Errors'
}

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> baselineData [
	^ baselineData
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> baselineData: anObject [
	baselineData := anObject
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> defaultMessageText [
	^ 'Mismatch when loading {1} between existing iceberg repo and baseline spec for "{2}"; baseline spec: {3}; iceberg: {4}' format: { 
		self baselineName.
		self mismatchType.
		self baselineData.
		self icebergData }
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> icebergData [
	^ icebergData
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> icebergData: anObject [
	icebergData := anObject
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> mismatchType [
	^ mismatchType
]

{ #category : #accessing }
GtRlClonerIcebergRepoMismatchError >> mismatchType: anObject [
	mismatchType := anObject
]
