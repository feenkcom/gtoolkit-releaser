Class {
	#name : #GtRlProjectReleaseBaselinePrinterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #baselines }
GtRlProjectReleaseBaselinePrinterExamples >> baselineForSystemFiveNullProjectRelease [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''GtRlBaselineExampleSystemFiveComponentA'' with: [
				spec repository: ''github://example/SystemFive:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleSystemFiveComponentB'' with: [
				spec repository: ''github://example/SystemFive:unknown/src'' ].

		spec package: ''PackageA'' with: [
			spec requires: #(#GtRlBaselineExampleSystemFiveComponentA) ].
		spec package: ''PackageB'' with: [
			spec requires: #(#PackageA #GtRlBaselineExampleSystemFiveComponentB) ].
		spec package: ''PackageC'' with: [
			spec requires: #(#GtRlBaselineExampleSystemFiveComponentB) ].
	]'
]

{ #category : #baselines }
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

{ #category : #baselines }
GtRlProjectReleaseBaselinePrinterExamples >> baselineForSystemTwoNullProjectRelease [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''GtRlBaselineExampleComponentA2'' with: [
				spec repository: ''github://example/SystemTwo:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleComponentB2Main'' with: [
				spec repository: ''github://example/SystemTwo:unknown/src'' ].
		spec
			baseline: ''GtRlBaselineExampleComponentC2'' with: [
				spec repository: ''github://example/SystemTwo:unknown/src'' ].
	]'
]

{ #category : #printing }
GtRlProjectReleaseBaselinePrinterExamples >> printSystemFiveProjectRelease [
	<gtExample>
	| projectRelease printer |
	projectRelease := BaselineOfGtRlBaselineExampleSystemFive
		gtRlProjectReleaseWithRepository: 'github://example/SystemFive/src' 
		withConfiguration: (GtRlReleaseConfiguration new 
			defaultReleaseStrategy: GtRlNullReleaseStrategy new).
	
	printer := GtRlProjectReleaseBaselineGenerator forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineForSystemFiveNullProjectRelease.
	
	^ printer
]

{ #category : #printing }
GtRlProjectReleaseBaselinePrinterExamples >> printSystemOneManualProjectRelease [
	<gtExample>
	| projectRelease printer |
	projectRelease := GtRlSystemOneReleaseExamples new projectReleaseSystem.
	printer := GtRlProjectReleaseBaselineGenerator forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineForSystemOneManualProjectRelease.
	
	^ printer
]

{ #category : #printing }
GtRlProjectReleaseBaselinePrinterExamples >> printSystemTwoProjectRelease [
	<gtExample>
	| projectRelease printer |
	projectRelease := BaselineOfGtRlBaselineExampleSystemTwo 
		gtRlProjectReleaseWithRepository: 'github://example/SystemTwo/src' 
		withConfiguration: (GtRlReleaseConfiguration new 
			defaultReleaseStrategy: GtRlNullReleaseStrategy new).
	
	printer := GtRlProjectReleaseBaselineGenerator forProjectRelease: projectRelease.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineForSystemTwoNullProjectRelease.
	
	^ printer
]
