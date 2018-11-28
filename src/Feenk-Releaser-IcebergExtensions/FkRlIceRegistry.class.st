Class {
	#name : #FkRlIceRegistry,
	#superclass : #Object,
	#instVars : [
		'repositories'
	],
	#category : #'Feenk-Releaser-IcebergExtensions'
}

{ #category : #private }
FkRlIceRegistry >> fromTextToRopedText: aText [
	"Conversion just for this particular case."
	| ropedText |
	aText isText ifFalse: [ ^ aText asRopedText ].
	ropedText := aText asRopedText.
	aText runs first 
		detect: [ :each | each class = TextColor ] 
		ifFound: [ :anAttribute | ropedText foreground:  anAttribute color ] 
		ifNone: [  ].
	^ ropedText
]

{ #category : #ui }
FkRlIceRegistry >> gtRepositoriesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories' translated;
		items: [ IceRepository registry collect: [ :each | IceTipRepositoryModel on: each ] ];
		column: 'Name' item: [ :aRepositoryModel | 
			self fromTextToRopedText: aRepositoryModel descriptionWithDecoration ];
		column: 'Branch' item: [ :aRepositoryModel | aRepositoryModel branchName ];
		column: 'Status' item: [ :aRepositoryModel | 
			self fromTextToRopedText: aRepositoryModel status ];
		send: [ :aRepositoryModel | aRepositoryModel entity ]
		
		
]

{ #category : #accessing }
FkRlIceRegistry >> repositories [
	^ repositories
]

{ #category : #accessing }
FkRlIceRegistry >> repositories: aCollection [
	repositories := aCollection
]
