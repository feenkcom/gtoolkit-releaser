"
I provide an abstraction for identify a concrete version for a repository or project release.

My subclasses provide the actual version number. This can be any information that can identify a release within a repository.
"
Class {
	#name : #GtRlVersionNumber,
	#superclass : #Object,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlVersionNumber >> description [ 
	^ self versionString
]

{ #category : #printing }
GtRlVersionNumber >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self description;
		nextPut: $)
]

{ #category : #accessing }
GtRlVersionNumber >> versionString [
	self subclassResponsibility
]
