Class {
	#name : #GtRlClonerBaselineEvent,
	#superclass : #BeaconSignal,
	#instVars : [
		'baselineName',
		'repositoryUrlString'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlClonerBaselineEvent >> baselineName [
	^ baselineName
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> baselineName: anObject [
	baselineName := anObject
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> repositoryUrlString [
	^ repositoryUrlString
]

{ #category : #accessing }
GtRlClonerBaselineEvent >> repositoryUrlString: anObject [
	repositoryUrlString := anObject
]
