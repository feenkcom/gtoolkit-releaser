Class {
	#name : #FkRlReleaseStragegy,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #testing }
FkRlReleaseStragegy >> allowsReleaseGeneration [
	^ true
]

{ #category : #versions }
FkRlReleaseStragegy >> releaseTarget [
	self subclassResponsibility
]
