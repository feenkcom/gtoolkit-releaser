Class {
	#name : #GtRlMajorVersionComputation,
	#superclass : #GtRlSemanticVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlMajorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersionNumber 
		major: aSemanticVersion major + 1
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch
]
