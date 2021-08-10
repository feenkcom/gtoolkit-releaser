Class {
	#name : #BaselineOfGtRlBaselineExampleSystemFive,
	#superclass : #BaselineOf,
	#category : 'GToolkit-Releaser-BaselineModel-SystemFiveExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemFive >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GtRlBaselineExampleSystemFiveComponentA' with: [
				spec repository: 'github://example/SystemFive/src' ].
		spec
			baseline: 'GtRlBaselineExampleSystemFiveComponentB' with: [
				spec repository: 'github://example/SystemFive/src' ].

		spec package: 'PackageA' with: [
			spec requires: #('GtRlBaselineExampleSystemFiveComponentA') ].
		spec package: 'PackageB' with: [
			spec requires: #('PackageA' 'GtRlBaselineExampleSystemFiveComponentB') ].
		spec package: 'PackageC' with: [
			spec requires: #('GtRlBaselineExampleSystemFiveComponentB') ].
	]
]
