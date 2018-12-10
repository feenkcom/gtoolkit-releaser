Class {
	#name : #GtRlVersionNumber,
	#superclass : #Object,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlVersionNumber >> description [ 
	^ self versionString
]

{ #category : #accessing }
GtRlVersionNumber >> versionString [
	self subclassResponsibility
]
