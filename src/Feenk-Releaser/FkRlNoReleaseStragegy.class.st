Class {
	#name : #FkRlNoReleaseStragegy,
	#superclass : #FkRlReleaseStragegy,
	#category : #'Feenk-Releaser'
}

{ #category : #testing }
FkRlNoReleaseStragegy >> allowsReleaseGeneration [
	^ false
]

{ #category : #versions }
FkRlNoReleaseStragegy >> releaseTarget [
	^ '--ignored--'
]
