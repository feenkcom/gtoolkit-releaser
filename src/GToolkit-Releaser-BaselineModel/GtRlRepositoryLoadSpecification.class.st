"
I indicate the location of a repository. 

I rely on a url to model the location. I follow the same conventions as Metacello project specs.


"
Class {
	#name : 'GtRlRepositoryLoadSpecification',
	#superclass : 'Object',
	#instVars : [
		'specificationUrl'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : 'instance creation' }
GtRlRepositoryLoadSpecification class >> fromUrlString: aString [
	^ self new
		specificationUrl: (ZnUrl fromString: aString)
]

{ #category : 'comparing' }
GtRlRepositoryLoadSpecification >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self specificationString asSymbol == anotherObject specificationString asSymbol
]

{ #category : 'testing' }
GtRlRepositoryLoadSpecification >> hasVersion [
	^ self specificationUrl segments first includes: $:
]

{ #category : 'comparing' }
GtRlRepositoryLoadSpecification >> hash [ 
	^ self class hash 
		bitXor: self specificationUrl hash
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> nameSegment [
	| size segmentIndex |
	size := self specificationUrl segments size. 
	segmentIndex := size - 1. 
	segmentIndex == 0 ifTrue: [ segmentIndex := 1 ].
	^ self specificationUrl segments at: segmentIndex.
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> projectName [
	| firstSegment |
	firstSegment := self specificationUrl segments first.
	^ (firstSegment includes: $:)
		ifTrue: [ firstSegment copyUpTo: $: ]
		ifFalse: [ firstSegment ]
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> repositoryName [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyUpTo: $: ]
		ifFalse: [ nameSegment ]
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> specificationId [ 	
	| urlCopy |
	urlCopy := self specificationUrl copy.
	urlCopy segments: OrderedCollection new. 
	urlCopy addPathSegment: self projectName.
	(self specificationUrl segments size > 1)
		ifTrue: [ urlCopy addPathSegments: (self specificationUrl segments 
			copyFrom: 2 to: self specificationUrl segments size )  ].
	^ urlCopy asString.
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> specificationString [
	^ self specificationUrl asString
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> specificationUrl [
	^ specificationUrl
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> specificationUrl: aZnUrl [
	self assert: [ aZnUrl notNil ].
	
	specificationUrl := aZnUrl
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> urlWithVersion: aVersionString [
	| currentUrl |
	currentUrl := self specificationUrl copy.
	currentUrl segments at: 1 put: self projectName,':', aVersionString. 
	^ currentUrl
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> versionString [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyAfter: $: ]
		ifFalse: [ Error signal: 'The repository does not have a version number.' ]
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecification >> versionStringOrNil [
	^ self hasVersion 
		ifTrue: [ self versionString ] 
		ifFalse: [ nil ]
]
