Class {
	#name : #GtRlNoReleaseStragegy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'Feenk-Releaser'
}

{ #category : #testing }
GtRlNoReleaseStragegy >> allowsReleaseGeneration [
	^ false
]

{ #category : #versions }
GtRlNoReleaseStragegy >> releaseTarget [
	^ '--ignored--'
]
