Class {
	#name : #GtRlProjectLoadDirectiveAction,
	#superclass : #Object,
	#instVars : [
		'loadDirective',
		'isExecuted'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #printing }
GtRlProjectLoadDirectiveAction >> descriptionDetails [
	self subclassResponsibility
]

{ #category : #logging }
GtRlProjectLoadDirectiveAction >> emitExecutionSignal [
	
]

{ #category : #execution }
GtRlProjectLoadDirectiveAction >> execute [ 
	isExecuted ifTrue: [ Error signal: 'Action already executed' ].
	self emitExecutionSignal.
	[ self performAction ] 
		ensure: [ isExecuted := true ].
]

{ #category : #accessing }
GtRlProjectLoadDirectiveAction >> isExecuted [
	^ isExecuted ifNil: [ false ]
]

{ #category : #accessing }
GtRlProjectLoadDirectiveAction >> loadDirective [
	^ loadDirective
]

{ #category : #accessing }
GtRlProjectLoadDirectiveAction >> loadDirective: anObject [
	loadDirective := anObject
]

{ #category : #accessing }
GtRlProjectLoadDirectiveAction >> name [
	self subclassResponsibility
]

{ #category : #actions }
GtRlProjectLoadDirectiveAction >> performAction [
	self subclassResponsibility
]
