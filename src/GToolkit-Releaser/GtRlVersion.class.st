Class {
	#name : #GtRlVersion,
	#superclass : #Object,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlVersion >> description [ 
	^ self versionString
]

{ #category : #accessing }
GtRlVersion >> versionString [
	self subclassResponsibility
]
