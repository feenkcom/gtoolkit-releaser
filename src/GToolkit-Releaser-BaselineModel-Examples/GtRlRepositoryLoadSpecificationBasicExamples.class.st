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
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := GtRlRepositoryLoadSpecification
			fromUrlString: self specificationUrlString.

	self assert: loadSpecification class equals: self specificationClass.
	self
		assert: loadSpecification specificationString
		equals: self specificationUrlString.

	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationEqualsSameInstance [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification equals: self loadSpecification.

	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationEqualsSelf [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification = loadSpecification.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHasCorrectId [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification specificationId equals: self specificationId.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHasVersion [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification hasVersion equals: self specificationHasVersion.

	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHashEqualsBetweenSameInstance [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification hash equals: self loadSpecification hash.

	^ loadSpecification
]

{ #category : #'examples - comparison' }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHashNotEqualUrlHash [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self
		assert: (loadSpecification hash = loadSpecification specificationString hash) not.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationHost [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification host equals: self specificationHost.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationProjectName [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self
		assert: loadSpecification projectName
		equals: self specificationProjectName.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationRepoPath [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification repoPath equals: self specificationRepoPath.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationUrlWithVersion [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self
		assert: (loadSpecification urlWithVersion: 'v2.0.24')
		equals: self specificationUrlWithVersion2024.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationBasicExamples >> loadSpecificationVersionString [
	<gtExample>
	<return: #SubclassResponsibility>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self specificationHasVersion
		ifTrue: [ self
				assert: loadSpecification versionString
				equals: self specificationVersionString ].

	^ loadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationHasVersion [
	^ self specificationVersionString isNotNil
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationHost [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationId [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationProjectName [
	<return: #String>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationRepoPath [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationUrlString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationUrlWithVersion2024 [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationBasicExamples >> specificationVersionString [
	<return: #String or: nil>
	^ self subclassResponsibility
]
