"
I provide an abstraction for identify a concrete version number for a repository or project release.

My subclasses provide the actual version number. This can be any information that can identify a release within a repository.
All my subclasses should provide immutable versions numbers. Once created a version number should not change.


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

{ #category : #testing }
GtRlVersionNumber >> isNullVersion [
	^ false
]

{ #category : #testing }
GtRlVersionNumber >> isSemanticVersion [

	^ false
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
