Class {
	#name : #GtRlClonerBaselineError,
	#superclass : #Error,
	#instVars : [
		'baselineSpec'
	],
	#category : 'GToolkit-Releaser-Cloner-Errors'
}

{ #category : #accessing }
GtRlClonerBaselineError >> baselineName [
	^ self baselineSpec baselineName
]

{ #category : #accessing }
GtRlClonerBaselineError >> baselineSpec [
	^ baselineSpec
]

{ #category : #accessing }
GtRlClonerBaselineError >> baselineSpec: anObject [
	baselineSpec := anObject
]

{ #category : #accessing }
GtRlClonerBaselineError >> defaultMessageText [
	^ ''
]

{ #category : #accessing }
GtRlClonerBaselineError >> messageText [
	"Return an exception's message text."

	^ messageText ifNil: [ self defaultMessageText ]
]

{ #category : #accessing }
GtRlClonerBaselineError >> repositoryLocation [
	^ self baselineSpec repositoryLocation
]
