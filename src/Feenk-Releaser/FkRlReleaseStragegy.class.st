Class {
	#name : #FkRlReleaseStragegy,
	#superclass : #Object,
	#instVars : [
		'repositoryRelease'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #testing }
FkRlReleaseStragegy >> allowsReleaseGeneration [
	^ true
]

{ #category : #accessing }
FkRlReleaseStragegy >> releaseTarget [
	self subclassResponsibility
]

{ #category : #accessing }
FkRlReleaseStragegy >> repositoryRelease [
	^ repositoryRelease
]

{ #category : #accessing }
FkRlReleaseStragegy >> repositoryRelease: aRepositoryRelease [
	repositoryRelease := aRepositoryRelease
]
