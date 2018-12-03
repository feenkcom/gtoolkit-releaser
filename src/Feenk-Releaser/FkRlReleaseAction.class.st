Class {
	#name : #FkRlReleaseAction,
	#superclass : #Object,
	#instVars : [
		'order'
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

{ #category : #ui }
FkRlReleaseAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description' translated;
		priority: 5;
		text: [ self description asRopedText ]
	
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

{ #category : #accessing }
FkRlReleaseAction >> repositoryRelease [
	self subclassResponsibility
]
