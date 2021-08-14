Class {
	#name : 'GtRlRepositoryLoadSpecificationForGithubWithTagExamples',
	#superclass : 'GtRlRepositoryLoadSpecificationBasicExamples',
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : 'examples' }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> loadSpecificationHasCorrectVersion [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification hasVersion.
	self assert: loadSpecification versionString equals: 'v0.2.1'.
	self assert: loadSpecification versionStringOrNil equals: 'v0.2.1'.
	
	^ loadSpecification
]

{ #category : 'examples' }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> loadSpecificationHasNames [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification projectName equals: 'gtoolkit'.
	self assert: loadSpecification repositoryName equals: 'gtoolkit'.
	
	^ loadSpecification
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationId [
	^ 'github://example/gtoolkit/src'
]

{ #category : 'accessing' }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationUrlString [
	^ 'github://example/gtoolkit:v0.2.1/src'
]
