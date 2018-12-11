Class {
	#name : #GtRlNullReleaseBuildStragegy,
	#superclass : #GtRlReleaseStragegy,
	#category : #'GToolkit-Releaser'
}

{ #category : #testing }
GtRlNullReleaseBuildStragegy >> allowsReleaseGeneration [
	^ false
]

{ #category : #versions }
GtRlNullReleaseBuildStragegy >> releaseTarget [
	^ '--ignored--'
]
