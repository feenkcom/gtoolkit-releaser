"
I increment the minor number of a semantic version.
"
Class {
	#name : #GtRlMinorVersionComputation,
	#superclass : #GtRlSemanticVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlMinorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersionNumber 
		major: aSemanticVersion major
		minor: aSemanticVersion minor + 1 
		patch: aSemanticVersion patch
]
