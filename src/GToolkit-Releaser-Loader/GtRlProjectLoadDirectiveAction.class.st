Class {
	#name : #GtRlProjectLoadDirectiveAction,
	#superclass : #Object,
	#instVars : [
		'loadDirective',
		'isExecuted'
	],
	#category : #'GToolkit-Releaser-Loader-Core'
}

{ #category : #printing }
GtRlProjectLoadDirectiveAction >> descriptionDetails [
	self subclassResponsibility
]

{ #category : #logging }
GtRlProjectLoadDirectiveAction >> emitExecutionCompletedSignal [
	GtRlLoaderDirectiveActionExecutionCompletedSignal new
		baselineName: loadDirective projectName;
		actionType: self className;
		actionDescription: self descriptionDetails;
		repositoryUrlString: loadDirective project repository loadSpecificationString;
		emit
]

{ #category : #logging }
GtRlProjectLoadDirectiveAction >> emitExecutionStartedSignal [
	GtRlLoaderDirectiveActionExecutionStartedSignal new
		baselineName: loadDirective projectName;
		actionType: self className;
		actionDescription: self descriptionDetails;
		repositoryUrlString: loadDirective project repository loadSpecificationString;
		emit
]

{ #category : #execution }
GtRlProjectLoadDirectiveAction >> execute [ 
	self isExecuted ifTrue: [ Error signal: 'Action already executed' ].
	self emitExecutionStartedSignal.
	[ 
		self performAction.
		self emitExecutionCompletedSignal
	] ensure: [ isExecuted := true ].
]

{ #category : #testing }
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
