Class {
	#name : #GtRlReleaseStragegy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #testing }
GtRlReleaseStragegy >> allowsReleaseGeneration [
	^ true
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
