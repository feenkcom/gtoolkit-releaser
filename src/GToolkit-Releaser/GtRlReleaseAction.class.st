"
I model an action executed during the creation of a new release version.

My main API method for executing the actions is ${method:GtRlReleaseAction>>#execute}$. Since release actions can have side effects, like creating tags, or merging branches I ensure that I am executed only once. Subclasses should implement ${method:GtRlReleaseAction>>#performAction}$ to provide a concrete execution logic.
"
Class {
	#name : #GtRlReleaseAction,
	#superclass : #Object,
	#instVars : [
		'order',
		'isExecuted'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlReleaseAction >> description [ 	
	self subclassResponsibility
]

{ #category : #printing }
GtRlReleaseAction >> descriptionDetails [
	^ ''
]

{ #category : #accessing }
GtRlReleaseAction >> emitCreationSignal [
	(GtRlCreateReleaseActionSignal action: self) emit.
]

{ #category : #accessing }
GtRlReleaseAction >> emitExecutionSignal [
	(GtRlExecuteActionSignal action: self) emit.
]

{ #category : #actions }
GtRlReleaseAction >> execute [
	isExecuted ifTrue: [ Error signal: 'Action already executed' ].
	self emitExecutionSignal.
	[ self performAction ] 
		ensure: [ isExecuted := true ].
]

{ #category : #ui }
GtRlReleaseAction >> gtActionExecuteFor: anAction [
	<gtAction>
	self isExecuted ifTrue: [ ^ anAction ].
	^ anAction button
			icon: BrGlamorousIcons go asElement;
			label: 'Execute action';
			action: [ self execute ]
]

{ #category : #ui }
GtRlReleaseAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description' translated;
		priority: 5;
		text: [ self description asRopedText ]
	
]

{ #category : #initialization }
GtRlReleaseAction >> initialize [ 
	super initialize.
	isExecuted := false
]

{ #category : #testing }
GtRlReleaseAction >> isExecuted [
	^ isExecuted notNil and: [ isExecuted ]
]

{ #category : #printing }
GtRlReleaseAction >> name [ 	
	^ 'Release action'
]

{ #category : #accessing }
GtRlReleaseAction >> order [
	^ order
]

{ #category : #accessing }
GtRlReleaseAction >> order: anInteger [
	order := anInteger
]

{ #category : #actions }
GtRlReleaseAction >> performAction [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlReleaseAction >> repositoryRelease [
	self subclassResponsibility
]
