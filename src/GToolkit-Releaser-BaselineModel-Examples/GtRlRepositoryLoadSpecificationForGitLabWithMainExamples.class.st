Class {
	#name : #GtRlRepositoryLoadSpecificationForGitLabWithMainExamples,
	#superclass : #GtRlRepositoryLoadSpecificationBasicExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationClass [
	^ GtRlRepositoryGitLabLoadSpecification
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationHost [
	^ 'ssh.git.feenk.com'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationId [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationProjectName [
	^ 'project'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationUrlString [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project:main/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationUrlWithVersion2024 [
	^ 'gitlab://ssh.git.feenk.com:projects/subproject1/subproject2/project:v2.0.24/src'
]

{ #category : #accessing }
GtRlRepositoryLoadSpecificationForGitLabWithMainExamples >> specificationVersionString [
	^ 'main'
]
