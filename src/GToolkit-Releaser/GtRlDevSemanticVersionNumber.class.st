Class {
	#name : #GtRlDevSemanticVersionNumber,
	#superclass : #GtRlSemanticVersionNumber,
	#category : #'GToolkit-Releaser'
}

{ #category : #accesing }
GtRlDevSemanticVersionNumber class >> devVersionIdentifier [
	^ 'DEV '
]

{ #category : #converting }
GtRlDevSemanticVersionNumber class >> readFromString: aString [
	| versionString tokens |
	versionString := aString copyFrom: self devVersionIdentifier size + 1 to: aString size.
	tokens := versionString allButFirst findTokens: '.'. 
	^ self 
		major: tokens first asInteger
		minor: tokens second asInteger
		patch: tokens third asInteger. 
]

{ #category : #converting }
GtRlDevSemanticVersionNumber >> asDevSemanticVersion [
	^ self
]

{ #category : #accessing }
GtRlDevSemanticVersionNumber >> versionString [
	^ self class devVersionIdentifier, super versionString
]
