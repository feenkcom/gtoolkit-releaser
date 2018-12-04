Class {
	#name : #GtRlVersion,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlVersion >> description [ 
	^ self versionString
]

{ #category : #accessing }
GtRlVersion >> versionString [
	self subclassResponsibility
]
