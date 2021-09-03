Class {
	#name : 'GtRlIceRegistry',
	#superclass : 'Object',
	#instVars : [
		'repositories'
	],
	#category : 'GToolkit-Releaser-IcebergExtensions'
}

{ #category : 'instance creation' }
GtRlIceRegistry class >> forAllIcebergRepositories [
	^ self new 
		repositories: IceRepository registry
]

{ #category : 'instance creation' }
GtRlIceRegistry class >> forRepositories: aCollection [
	^ self new 	
		repositories: aCollection
]

{ #category : 'private' }
GtRlIceRegistry >> fromTextToRopedText: aText [
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

{ #category : 'ui' }
GtRlIceRegistry >> gtRepositoriesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories' translated;
		items: [ self repositoryModels ];
		column: 'Name' text: [ :aRepositoryModel | 
			self fromTextToRopedText: aRepositoryModel descriptionWithDecoration ];
		column: 'Branch' text: [ :aRepositoryModel | aRepositoryModel branchName ];
		column: 'Status' text: [ :aRepositoryModel | 
			self fromTextToRopedText: aRepositoryModel status ];
		send: [ :aRepositoryModel | aRepositoryModel entity ];
		actionStencil: [ :aTab | 
			BrButton new  
				aptitude: BrGlamorousButtonWithLabelAptitude;
				label: 'Fetch';
				action: [ 
					self repositoryModels do: #fetch.
					"aTab viewContentElement phlow update" ] ]
		
		
]

{ #category : 'accessing' }
GtRlIceRegistry >> repositories [
	^ repositories
]

{ #category : 'accessing' }
GtRlIceRegistry >> repositories: aCollection [
	repositories := aCollection
]

{ #category : 'accessing' }
GtRlIceRegistry >> repositoryModels [
	^ self repositories collect: [ :each | 
		IceTipRepositoryModel on: each ]
]

{ #category : 'enumerating' }
GtRlIceRegistry >> select: aBloc [
	^ self class forRepositories: (self repositories select: aBloc)
]
