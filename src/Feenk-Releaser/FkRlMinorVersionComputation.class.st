Class {
	#name : #FkRlMinorVersionComputation,
	#superclass : #FkRlSymbolicVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlMinorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ FkRlSemanticVersion 
		major: aSemanticVersion major
		minor: aSemanticVersion minor + 1 
		patch: aSemanticVersion patch
]
