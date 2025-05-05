Class {
	#name : #GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> loadSpecificationHasCorrectVersion [
	<gtExample>
	<return: #GtRlRepositoryDefaultLoadSpecification>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification hasVersion not.
	self assert: loadSpecification versionStringOrNil isNil.

	^ loadSpecification
]

{ #category : #examples }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> loadSpecificationHasNames [
	<gtExample>
	<return: #GtRlRepositoryDefaultLoadSpecification>
	| loadSpecification |
	loadSpecification := self loadSpecification.

	self assert: loadSpecification projectName equals: 'gtoolkit'.
	self assert: loadSpecification repositoryName equals: 'gtoolkit'.

	^ loadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationClass [
	^ GtRlRepositoryDefaultLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationHost [
	^ 'example'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationId [
	^ 'github://example/gtoolkit/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationProjectName [
	^ 'gtoolkit'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationRepoPath [
	^ 'src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationUrlString [
	^ 'github://example/gtoolkit/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationUrlWithVersion2024 [
	^ 'github://example/gtoolkit:v2.0.24/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGithubWithNoVersionExamples >> specificationVersionString [
	^ nil
]
