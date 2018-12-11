Class {
	#name : #GtRlPatchVersionComputation,
	#superclass : #GtRlSemanticVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlPatchVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersionNumber 
		major: aSemanticVersion major
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch + 1
]
