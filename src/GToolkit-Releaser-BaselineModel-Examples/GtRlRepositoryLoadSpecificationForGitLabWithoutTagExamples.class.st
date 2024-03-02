Class {
	#name : #GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationClass [
	^ GtRlRepositoryGitLabLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationHost [
	^ 'ssh.git.feenk.com'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationId [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationProjectName [
	^ 'project'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationUrlString [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationUrlWithVersion2024 [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project:v2.0.24/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithoutTagExamples >> specificationVersionString [
	^ nil
]
