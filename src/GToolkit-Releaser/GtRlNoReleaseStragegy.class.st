Class {
	#name : #GtRlNoReleaseStragegy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'GToolkit-Releaser'
}

{ #category : #testing }
GtRlNoReleaseStragegy >> allowsReleaseGeneration [
	^ false
]

{ #category : #versions }
GtRlNoReleaseStragegy >> releaseTarget [
	^ '--ignored--'
]
