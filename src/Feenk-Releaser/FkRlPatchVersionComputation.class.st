Class {
	#name : #FkRlPatchVersionComputation,
	#superclass : #FkRlSymbolicVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlPatchVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ FkRlSemanticVersion 
		major: aSemanticVersion major
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch + 1
]
