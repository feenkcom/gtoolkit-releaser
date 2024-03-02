Class {
	#name : #GtRlRepositoryLoadSpecificationForFiletreeExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> loadSpecificationHasCorrectVersion [
	<gtExample>
	| loadSpecification |
	loadSpecification := self loadSpecification.
	
	self assert: loadSpecification hasVersion not.
	self assert: loadSpecification versionStringOrNil isNil.
	
	^ loadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationClass [
	^ GtRlRepositoryDefaultLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationHost [
	^ nil
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationId [
	^ 'filetree:///Users/example/Documents/temp/repo'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationProjectName [
	^ 'Users'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationUrlString [
	^ 'filetree:///Users/example/Documents/temp/repo'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationUrlWithVersion2024 [
	^ 'filetree:///Users:v2.0.24/example/Documents/temp/repo'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForFiletreeExamples >> specificationVersionString [
	^ nil
]
