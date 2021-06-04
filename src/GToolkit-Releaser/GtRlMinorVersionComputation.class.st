"
I increment the minor number of a semantic version. I reset the minor part of version number to zero.

{{gtExample:GtRlSemanticVersionComputationExamples>>#nextMinorVersionComputation}}

If the symbolic version number on which I am applied has a patch number I reset it to zero in the created version number.
{{gtExample:GtRlSemanticVersionComputationExamples>>#nextMinorVersionComputationResettingPatchNumber}}


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
		patch: 0 "Reset to zero"
]
