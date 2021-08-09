Class {
	#name : 'GtRlProjectReleaseBaselinePrinterExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : 'baselines' }
GtRlProjectReleaseBaselinePrinterExamples >> baselineForSystemOneManualProjectRelease [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''GtRlBaselineExampleComponentA'' with: [
				spec repository: ''github://example/ComponentA:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleComponentBMain'' with: [
				spec repository: ''github://example/ComponentB:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleComponentC'' with: [
				spec repository: ''github://example/ComponentC:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleComponentD'' with: [
				spec repository: ''github://example/ComponentD:unknown/src'' ].
	]'
]

{ #category : 'printing' }
GtRlProjectReleaseBaselinePrinterExamples >> printSystemOneManualProjectRelease [
	<gtExample>
	| projectRelease printer |
	projectRelease := GtRlSystemOneReleaseExamples new projectReleaseSystem.
	printer := GtRlProjectReleaseBaselinePrinter forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineForSystemOneManualProjectRelease.
	
	^ printer
]
