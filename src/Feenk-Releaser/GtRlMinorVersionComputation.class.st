Class {
	#name : #GtRlMinorVersionComputation,
	#superclass : #GtRlSymbolicVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
GtRlMinorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersion 
		major: aSemanticVersion major
		minor: aSemanticVersion minor + 1 
		patch: aSemanticVersion patch
]
