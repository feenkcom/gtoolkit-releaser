Class {
	#name : #GtRlSemanticVersionComputationExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #'as yet unclassified' }
GtRlSemanticVersionComputationExamples >> nextMajorVersionComputation [
	<gtExample>
	| versionComputation |
	versionComputation := GtRlMajorVersionComputation new.
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 0))
		equals: (GtRlSemanticVersionNumber major:1 minor: 0 patch: 0).
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 0 patch: 0))
		equals: (GtRlSemanticVersionNumber major:2 minor: 0 patch: 0).
	
	^ versionComputation
	
]

{ #category : #'as yet unclassified' }
GtRlSemanticVersionComputationExamples >> nextMajorVersionComputationResettingPatchAndMinorNumbers [
	<gtExample>
	| versionComputation |
	versionComputation := GtRlMajorVersionComputation new.
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 4 patch: 6))
		equals: (GtRlSemanticVersionNumber major:2 minor: 0 patch: 0).
	
	^ versionComputation
	
]

{ #category : #'as yet unclassified' }
GtRlSemanticVersionComputationExamples >> nextMinorVersionComputation [
	<gtExample>
	| versionComputation |
	versionComputation := GtRlMinorVersionComputation new.
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 0))
		equals: (GtRlSemanticVersionNumber major:0 minor: 1 patch: 0).
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 0))
		equals: (GtRlSemanticVersionNumber major:1 minor: 3 patch: 0).
	
	^ versionComputation
	
]

{ #category : #'as yet unclassified' }
GtRlSemanticVersionComputationExamples >> nextMinorVersionComputationResettingPatchNumber [
	<gtExample>
	| versionComputation |
	versionComputation := GtRlMinorVersionComputation new.
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 2))
		equals: (GtRlSemanticVersionNumber major:1 minor: 3 patch: 0).
	
	^ versionComputation
	
]

{ #category : #'as yet unclassified' }
GtRlSemanticVersionComputationExamples >> nextPatchVersionComputation [
	<gtExample>
	| versionComputation |
	versionComputation := GtRlPatchVersionComputation new.
	
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 0))
		equals: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 1).
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 0))
		equals: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 1).
	self 
		assert: (versionComputation nextSemanticVersionFrom: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 2))
		equals: (GtRlSemanticVersionNumber major:1 minor: 2 patch: 3).
	
	^ versionComputation
	
]
