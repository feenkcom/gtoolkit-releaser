Class {
	#name : #GtRlDevSemanticVersionNumber,
	#superclass : #GtRlSemanticVersionNumber,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlDevSemanticVersionNumber >> versionString [
	^ 'DEV ', super versionString
]
