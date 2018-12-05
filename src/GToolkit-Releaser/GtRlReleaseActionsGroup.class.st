Class {
	#name : #GtRlReleaseActionsGroup,
	#superclass : #Object,
	#instVars : [
		'actions'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #copying }
GtRlReleaseActionsGroup >> , anActionGroup [
	^ self class new
		addActions: (self actions, anActionGroup actions);
		yourself
]

{ #category : #accessing }
GtRlReleaseActionsGroup >> actions [ 
	^ actions
]

{ #category : #adding }
GtRlReleaseActionsGroup >> addAction: anAction [
	^ actions add: anAction
]

{ #category : #adding }
GtRlReleaseActionsGroup >> addActions: aCollectionOfActions [
	^ actions addAll: aCollectionOfActions
]

{ #category : #testing }
GtRlReleaseActionsGroup >> do: aBlock [
	^ actions do: aBlock
]

{ #category : #actions }
GtRlReleaseActionsGroup >> execute [
	self actions do: #execute
]

{ #category : #ui }
GtRlReleaseActionsGroup >> gtReleaseActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Release actions' translated;
		priority: 50;
		items: [ actions ifNil: [ #() ] ];
		column: 'Order' do: [ :aColumn | 
			aColumn 
				item: #order;
				width: 50 ];
		column: 'Repository' item: [ :anAction | anAction repositoryRelease repository id ];
		column: 'Action' item: [ :anAction | anAction name ];
		column: 'Details' item: #descriptionDetails
]

{ #category : #testing }
GtRlReleaseActionsGroup >> ifNotEmpty: aBlock [
	^ actions ifNotEmpty: aBlock
]

{ #category : #initialization }
GtRlReleaseActionsGroup >> initialize [ 
	super initialize.
	actions := OrderedCollection new
]

{ #category : #sorting }
GtRlReleaseActionsGroup >> sortedByOrder [
	^ self class new
		addActions: (self actions sorted: [ :a :b | a order < b order ]);
		yourself
]
