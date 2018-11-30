Class {
	#name : #FkRlVersion,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlVersion >> description [ 
	^ self versionString
]

{ #category : #accessing }
FkRlVersion >> versionString [
	self subclassResponsibility
]
