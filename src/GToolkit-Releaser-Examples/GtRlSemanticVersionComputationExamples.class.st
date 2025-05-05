Class {
	#name : #GtRlSemanticVersionComputationExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #'examples ' }
GtRlSemanticVersionComputationExamples >> nextMajorVersionComputation [
	<gtExample>
	<return: #GtRlMajorVersionComputation>
	| versionComputation |
	versionComputation := GtRlMajorVersionComputation new.
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 0
						minor: 0
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 1
				minor: 0
				patch: 0).
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 0
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 2
				minor: 0
				patch: 0).

	^ versionComputation
]

{ #category : #'examples ' }
GtRlSemanticVersionComputationExamples >> nextMajorVersionComputationResettingPatchAndMinorNumbers [
	<gtExample>
	<return: #GtRlMajorVersionComputation>
	| versionComputation |
	versionComputation := GtRlMajorVersionComputation new.
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 4
						patch: 6))
		equals: (GtRlSemanticVersionNumber
				major: 2
				minor: 0
				patch: 0).

	^ versionComputation
]

{ #category : #'examples ' }
GtRlSemanticVersionComputationExamples >> nextMinorVersionComputation [
	<gtExample>
	<return: #GtRlMinorVersionComputation>
	| versionComputation |
	versionComputation := GtRlMinorVersionComputation new.
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 0
						minor: 0
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 0
				minor: 1
				patch: 0).
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 2
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 1
				minor: 3
				patch: 0).

	^ versionComputation
]

{ #category : #'examples ' }
GtRlSemanticVersionComputationExamples >> nextMinorVersionComputationResettingPatchNumber [
	<gtExample>
	<return: #GtRlMinorVersionComputation>
	| versionComputation |
	versionComputation := GtRlMinorVersionComputation new.
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 2
						patch: 2))
		equals: (GtRlSemanticVersionNumber
				major: 1
				minor: 3
				patch: 0).

	^ versionComputation
]

{ #category : #'examples ' }
GtRlSemanticVersionComputationExamples >> nextPatchVersionComputation [
	<gtExample>
	<return: #GtRlPatchVersionComputation>
	| versionComputation |
	versionComputation := GtRlPatchVersionComputation new.

	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 0
						minor: 0
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 0
				minor: 0
				patch: 1).
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 2
						patch: 0))
		equals: (GtRlSemanticVersionNumber
				major: 1
				minor: 2
				patch: 1).
	self
		assert: (versionComputation
				nextSemanticVersionFrom: (GtRlSemanticVersionNumber
						major: 1
						minor: 2
						patch: 2))
		equals: (GtRlSemanticVersionNumber
				major: 1
				minor: 2
				patch: 3).

	^ versionComputation
]
