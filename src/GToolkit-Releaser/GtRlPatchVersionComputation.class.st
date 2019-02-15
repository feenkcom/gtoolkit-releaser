"
I increment the patch number of a semantic version. I leave the other parts of the semantic version unchanged.

${example:GtRlSemanticVersionComputationExamples>>#nextPatchVersionComputation}$

"
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
