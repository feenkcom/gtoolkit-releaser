Class {
	#name : #GtRlClonerBaselineError,
	#superclass : #Error,
	#instVars : [
		'baselineName',
		'repositoryUrlString'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlClonerBaselineError >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineError >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #accessing }
GtRlClonerBaselineError >> repositoryUrlString [
	^ repositoryUrlString
]

{ #category : #accessing }
GtRlClonerBaselineError >> repositoryUrlString: anObject [
	repositoryUrlString := anObject
]