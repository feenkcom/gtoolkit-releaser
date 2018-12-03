Class {
	#name : #FkRlReleaseActionsGroup,
	#superclass : #Object,
	#instVars : [
		'actions'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #copying }
FkRlReleaseActionsGroup >> , anActionGroup [
	^ self class new
		addActions: (self actions, anActionGroup actions);
		yourself
]

{ #category : #accessing }
FkRlReleaseActionsGroup >> actions [ 
	^ actions
]

{ #category : #adding }
FkRlReleaseActionsGroup >> addAction: anAction [
	^ actions add: anAction
]

{ #category : #adding }
FkRlReleaseActionsGroup >> addActions: aCollectionOfActions [
	^ actions addAll: aCollectionOfActions
]

{ #category : #testing }
FkRlReleaseActionsGroup >> do: aBlock [
	^ actions do: aBlock
]

{ #category : #ui }
FkRlReleaseActionsGroup >> gtReleaseActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Release actions' translated;
		priority: 50;
		items: [ actions ifNil: [ #() ] ];
		column: 'Order' item: #order;
		column: 'Repository' item: [ :anAction | anAction repositoryRelease repository id ];
		column: 'Action' item: [ :anAction | anAction name ];
		column: 'Details' item: #descriptionDetails
]

{ #category : #testing }
FkRlReleaseActionsGroup >> ifNotEmpty: aBlock [
	^ actions ifNotEmpty: aBlock
]

{ #category : #initialization }
FkRlReleaseActionsGroup >> initialize [ 
	super initialize.
	actions := OrderedCollection new
]

{ #category : #sorting }
FkRlReleaseActionsGroup >> sortedByOrder [
	^ self class new
		addActions: (self actions sorted: [ :a :b | a order < b order ]);
		yourself
]
