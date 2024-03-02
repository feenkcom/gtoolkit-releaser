Class {
	#name : #GtRlRepositoryDefaultLoadSpecification,
	#superclass : #GtRlRepositoryLoadSpecification,
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #testing }
GtRlRepositoryDefaultLoadSpecification >> hasVersion [
	^ specificationUrl segments first includes: $:
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> host [
	^ specificationUrl host
]

{ #category : #'initialization ' }
GtRlRepositoryDefaultLoadSpecification >> initializeWithString: aString [
	specificationUrl := ZnUrl fromString: aString
]

{ #category : #private }
GtRlRepositoryDefaultLoadSpecification >> nameSegment [
	| size segmentIndex |
	size := specificationUrl segments size. 
	segmentIndex := size - 1. 
	segmentIndex == 0 ifTrue: [ segmentIndex := 1 ].
	^ specificationUrl segments at: segmentIndex.
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> projectName [
	| firstSegment |
	firstSegment := specificationUrl segments first.
	^ (firstSegment includes: $:)
		ifTrue: [ firstSegment copyUpTo: $: ]
		ifFalse: [ firstSegment ]
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> repoPath [
	| urlSegments |
	urlSegments := specificationUrl segments.
	^ urlSegments size = 1 ifTrue: [ '' ] ifFalse: [ urlSegments last ]
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> repositoryName [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyUpTo: $: ]
		ifFalse: [ nameSegment ]
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> specificationId [
	"Without version part, e.g., :main, :v5.4.3"

	| urlCopy |
	urlCopy := specificationUrl copy.
	urlCopy segments: OrderedCollection new.
	urlCopy addPathSegment: self projectName.
	specificationUrl segments size > 1
		ifTrue: [ urlCopy
				addPathSegments: (specificationUrl segments
						copyFrom: 2
						to: specificationUrl segments size) ].
	^ urlCopy asString
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> specificationString [
	^ specificationUrl asString
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> urlWithVersion: aVersionString [
	| currentUrl |
	currentUrl := specificationUrl copy.
	currentUrl segments at: 1 put: self projectName,':', aVersionString. 
	^ currentUrl asString
]

{ #category : #accessing }
GtRlRepositoryDefaultLoadSpecification >> versionString [
	| nameSegment |
	nameSegment := self nameSegment.
	^ (nameSegment includes: $:)
		ifTrue: [ nameSegment copyAfter: $: ]
		ifFalse: [ Error signal: 'The repository does not have a version number.' ]
]
