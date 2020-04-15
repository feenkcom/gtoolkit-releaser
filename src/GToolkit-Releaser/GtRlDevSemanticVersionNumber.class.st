Class {
	#name : #GtRlDevSemanticVersionNumber,
	#superclass : #GtRlSemanticVersionNumber,
	#category : #'GToolkit-Releaser'
}

{ #category : #converting }
GtRlDevSemanticVersionNumber >> asDevSemanticVersion [
	^ self
]

{ #category : #accessing }
GtRlDevSemanticVersionNumber >> versionString [
	^ 'DEV ', super versionString
]
