"
I increment the major number of a semantic version. I reset both the patch and minor parts of the version number to zero.

{{gtExample:GtRlSemanticVersionComputationExamples>>#nextMajorVersionComputation}}

If the symbolic version number on which I am applied has a patch or a minor number I reset them to zero in the created version number.
{{gtExample:GtRlSemanticVersionComputationExamples>>#nextMajorVersionComputationResettingPatchAndMinorNumbers}}


"
Class {
	#name : #GtRlMajorVersionComputation,
	#superclass : #GtRlSemanticVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlMajorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersionNumber 
		major: aSemanticVersion major + 1
		minor: 0 "Reset to zero"
		patch: 0 "Reset to zero"
]
