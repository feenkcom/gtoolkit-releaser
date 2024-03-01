"
I indicate the location of a repository. 

I rely on a url to model the location. I follow the same conventions as Metacello project specs.


"
Class {
	#name : #GtRlRepositoryLoadSpecification,
	#superclass : #Object,
	#instVars : [
		'specificationUrl'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlRepositoryLoadSpecification class >> fromUrlString: aString [
	self
		subclassesDo: [ :aClass | 
			(aClass isAbstract not and: [ aClass isForUrlString: aString ])
				ifTrue: [ ^ aClass newFromString: aString ] ].

	^ GtRlRepositoryDefaultLoadSpecification newFromString: aString
]

{ #category : #'instance creation' }
GtRlRepositoryLoadSpecification class >> isForUrlString: aString [
	^ false
]

{ #category : #'instance creation' }
GtRlRepositoryLoadSpecification class >> newFromString: aString [
	^ self new initializeWithString: aString
]

{ #category : #comparing }
GtRlRepositoryLoadSpecification >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self specificationString asSymbol == anotherObject specificationString asSymbol
]

{ #category : #'gt - extensions' }
GtRlRepositoryLoadSpecification >> gtOverview [
	| aPrinter |
	aPrinter := [ :aBlock | 
		aBlock
			on: Error
			do: [ :anException | 
				anException printString asRopedText
					foreground: BrGlamorousColors errorBackgroundColor ] ].

	^ OrderedDictionary new
		at: 'Specification string'
			put: (aPrinter value: [ self specificationString ]);
		at: 'Specification ID' put: (aPrinter value: [ self specificationId ]);
		at: 'Project name' put: (aPrinter value: [ self projectName ]);
		at: 'Repository name' put: (aPrinter value: [ self repositoryName ]);
		at: 'Has version' put: (aPrinter value: [ self hasVersion ]);
		at: 'Version string' put: (aPrinter value: [ self versionStringOrNil ]);
		at: 'Specification with v2.0.24 version'
			put: (aPrinter value: [ self urlWithVersion: 'v2.0.24' ]);
		yourself
]

{ #category : #'gt - extensions' }
GtRlRepositoryLoadSpecification >> gtOverviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Overview';
		priority: 1;
		items: [ self gtOverview associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #testing }
GtRlRepositoryLoadSpecification >> hasVersion [
	^ self subclassResponsibility
]

{ #category : #comparing }
GtRlRepositoryLoadSpecification >> hash [ 
	^ self class hash 
		bitXor: self specificationString asSymbol hash
]

{ #category : #'initialization ' }
GtRlRepositoryLoadSpecification >> initializeWithString: aString [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> projectName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> repositoryName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> specificationId [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> specificationString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> urlWithVersion: aVersionString [
	<return: #String>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> versionString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecification >> versionStringOrNil [
	^ self hasVersion 
		ifTrue: [ self versionString ] 
		ifFalse: [ nil ]
]
