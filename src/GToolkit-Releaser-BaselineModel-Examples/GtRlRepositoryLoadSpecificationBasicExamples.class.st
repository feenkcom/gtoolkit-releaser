Class {
	#name : #GtRlRepositoryLoadSpecificationBasicExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #testing }
GtRlRepositoryLoadSpecificationBasicExamples class >> isAbstract [ 	
	^ self name = GtRlRepositoryLoadSpecificationBasicExamples name
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecification [
	<gtExample>
	| loadSpecification |
	loadSpecification := GtRlRepositoryLoadSpecification 
		fromUrlString: self specificationUrlString.
	
	self assert: loadSpecification specificationUrl equals: (ZnUrl fromString: self specificationUrlString).
	self assert: loadSpecification specificationString equals: self specificationUrlString.
	
	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationEqualsSameInstance [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification equals: self loadSpecification.
	
	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationEqualsSelf [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification = loadSpecification.
	
	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHasCorrectId [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification specificationId equals: self specificationId.
	
	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHashEqualsBetweenSameInstance [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification hash equals: self loadSpecification hash.
	
	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHashNotEqualUrlHash [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: (loadSpecification hash = loadSpecification specificationUrl hash) not.
	self assert: (loadSpecification hash = loadSpecification specificationString hash) not.
	
	^ loadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationId [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationUrlString [
	^ self subclassResponsibility
]
