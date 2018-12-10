Class {
	#name : #GtRlReleaseStragegy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #testing }
GtRlReleaseStragegy >> allowsReleaseGeneration [
	^ true
]

{ #category : #ui }
GtRlReleaseStragegy >> gtCommitsAncestryFor: aView [
	^ aView
]

{ #category : #accessing }
GtRlReleaseStragegy >> releaseTarget [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlReleaseStragegy >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
GtRlReleaseStragegy >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]
