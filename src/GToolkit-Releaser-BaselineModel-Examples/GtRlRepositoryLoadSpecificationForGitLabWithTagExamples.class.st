Class {
	#name : #GtRlRepositoryLoadSpecificationForGitLabWithTagExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationClass [
	^ GtRlRepositoryGitLabLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationId [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationProjectName [
	^ 'projects/subproject1/subproject2/project'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationUrlString [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project:v1.2.3/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationUrlWithVersion2024 [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project:v2.0.24/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithTagExamples >> specificationVersionString [
	^ 'v1.2.3'
]
