Class {
	#name : #GtRlRepositoryLoadSpecificationForGithubWithTagExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> loadSpecificationHasCorrectVersion [
	<gtExample>
	<return: #GtRlRepositoryDefaultLoadSpecification>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification hasVersion.
	self assert: loadSpecification versionString equals: 'v0.2.1'.
	self assert: loadSpecification versionStringOrNil equals: 'v0.2.1'.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> loadSpecificationHasNames [
	<gtExample>
	<return: #GtRlRepositoryDefaultLoadSpecification>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification projectName equals: 'gtoolkit'.
	self assert: loadSpecification repositoryName equals: 'gtoolkit'.

	^ loadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationClass [
	^ GtRlRepositoryDefaultLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationHost [
	^ 'example'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationId [
	^ 'github://example/gtoolkit/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationProjectName [
	^ 'gtoolkit'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationRepoPath [
	^ 'src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationUrlString [
	^ 'github://example/gtoolkit:v0.2.1/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationUrlWithVersion2024 [
	^ 'github://example/gtoolkit:v2.0.24/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithTagExamples >> specificationVersionString [
	^ 'v0.2.1'
]
