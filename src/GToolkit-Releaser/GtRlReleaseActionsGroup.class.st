"
I model a collection of release actions. I exist to provide an interface for simplifying inspecting and working with groups of actions.  

Some public API methods: 
	- ${method:GtRlReleaseActionsGroup>>#execute}$ - execute all release actions from this group
	- ${method:method:GtRlReleaseActionsGroup>>#sortedByOrder} - return a new group where actions are sorted based on the order attribute. 
"
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
	aCollectionOfActions do: [ :anAction |
		self addAction: anAction ].
	^ aCollectionOfActions
	
]

{ #category : #accessing }
GtRlReleaseActionsGroup >> count [
	^ self actions size
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
GtRlReleaseActionsGroup >> format: aString for: anAction [
	^ anAction isExecuted
		ifTrue: [ aString asRopedText foreground: Color gray ] 
		ifFalse: [ aString ]
]

{ #category : #ui }
GtRlReleaseActionsGroup >> gtReleaseActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Release actions' translated;
		priority: 50;
		items: [ self actions ifNil: [ #() ] ];
		column: 'Order' do: [ :aColumn | 
			aColumn 
				item: [ :anAction | anAction order ];
				width: 50 ];
		column: 'Repository' item: [ :anAction | 
			self format: anAction repositoryRelease repository id for: anAction ];
		column: 'Action' item: [ :anAction | 
			self format: anAction name for: anAction ];
		column: 'Details' item: [ :anAction | 
			self format: anAction descriptionDetails for: anAction ]
]

{ #category : #initialization }
GtRlReleaseActionsGroup >> initialize [ 
	super initialize.
	actions := OrderedCollection new
]

{ #category : #testing }
GtRlReleaseActionsGroup >> isEmpty [
	^ self actions isEmpty
]

{ #category : #filtering }
GtRlReleaseActionsGroup >> reject: aBlockClosure [ 
	^ self class new
		addActions: (self actions reject: aBlockClosure);
		yourself
		 
]

{ #category : #actions }
GtRlReleaseActionsGroup >> removeAll [
	self actions removeAll.
]

{ #category : #filtering }
GtRlReleaseActionsGroup >> select: aBlockClosure [ 
	^ self class new
		addActions: (self actions select: aBlockClosure);
		yourself
		 
]

{ #category : #sorting }
GtRlReleaseActionsGroup >> sortedByOrder [
	^ self class new
		addActions: (self actions sorted: [ :a :b | a order < b order ]);
		yourself
]
