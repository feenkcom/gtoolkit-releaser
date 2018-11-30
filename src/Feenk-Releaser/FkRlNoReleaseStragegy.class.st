Class {
	#name : #FkRlNoReleaseStragegy,
	#superclass : #FkRlReleaseStragegy,
	#category : #'Feenk-Releaser'
}

{ #category : #versions }
FkRlNoReleaseStragegy >> releaseTarget [
	^ '--ignored--'
]
