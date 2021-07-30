"
I increment the patch number of a semantic version. I leave the other parts of the semantic version unchanged.

{{gtExample:GtRlSemanticVersionComputationExamples>>#nextPatchVersionComputation}}


"
Class {
	#name : #GtRlPatchVersionComputation,
	#superclass : #GtRlSemanticVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlPatchVersionComputation >> nextMainSemanticVersionFrom: aSemanticVersion [
	^ GtRlMainSemanticVersionNumber 
		major: aSemanticVersion major
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch + 1
]

{ #category : #accessing }
GtRlPatchVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlMainSemanticVersionNumber 
		major: aSemanticVersion major
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch + 1
]
