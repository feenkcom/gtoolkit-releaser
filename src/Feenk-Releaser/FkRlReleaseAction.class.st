Class {
	#name : #FkRlReleaseAction,
	#superclass : #Object,
	#instVars : [
		'order',
		'isExecuted'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #printing }
FkRlReleaseAction >> description [ 	
	self subclassResponsibility
]

{ #category : #printing }
FkRlReleaseAction >> descriptionDetails [
	^ ''
]

{ #category : #actions }
FkRlReleaseAction >> execute [
	isExecuted ifTrue: [ Error signal: 'Action already executed' ].
	[ self performAction ] 
		ensure: [ isExecuted := true ].
]

{ #category : #ui }
FkRlReleaseAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description' translated;
		priority: 5;
		text: [ self description asRopedText ]
	
]

{ #category : #initialization }
FkRlReleaseAction >> initialize [ 
	super initialize.
	isExecuted := false
]

{ #category : #printing }
FkRlReleaseAction >> name [ 	
	^ 'Release action'
]

{ #category : #accessing }
FkRlReleaseAction >> order [
	^ order
]

{ #category : #accessing }
FkRlReleaseAction >> order: anInteger [
	order := anInteger
]

{ #category : #actions }
FkRlReleaseAction >> performAction [
	self subclassResponsibility
]

{ #category : #accessing }
FkRlReleaseAction >> repositoryRelease [
	self subclassResponsibility
]
