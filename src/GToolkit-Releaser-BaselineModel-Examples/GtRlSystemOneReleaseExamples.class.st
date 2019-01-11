Class {
	#name : #GtRlSystemOneReleaseExamples,
	#superclass : #GtRlSystemOneModelExamples,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'as yet unclassified' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentA [
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new
		project: self projectComponentA.
	repositoryRelease := self repositoryReleaseComponentA.
	
	^ projectRelease
]

{ #category : #'as yet unclassified' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentA [
	<gtExamples>
	| release |
	release := GtRlRepositoryRelease new
		repository: self repositoryComponentA.
		
	^ release
	
]
