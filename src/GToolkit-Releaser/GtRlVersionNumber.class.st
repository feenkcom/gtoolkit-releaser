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
