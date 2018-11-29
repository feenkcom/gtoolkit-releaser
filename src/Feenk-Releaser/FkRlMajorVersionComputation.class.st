Class {
	#name : #FkRlMajorVersionComputation,
	#superclass : #FkRlSymbolicVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlMajorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ FkRlSemanticVersion 
		major: aSemanticVersion major + 1
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch
]
