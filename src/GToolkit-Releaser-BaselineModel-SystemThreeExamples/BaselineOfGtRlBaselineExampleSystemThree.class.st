"
I am a baseline there are multiple dependencies to a child baseline. I am used in examples for GtReleaser.

The dependencies between baselines are shown in the figure below.
${example:BaselineOfGtRlBaselineExampleSystemThree class>>#itself|previewShow=#gtMapFor:|noCode}$

"
Class {
	#name : #BaselineOfGtRlBaselineExampleSystemThree,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemThreeExamples'
}

{ #category : #accessing }
BaselineOfGtRlBaselineExampleSystemThree class >> itself [
	<gtExample>
	^ self
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemThree >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: #GtRlBaselineExampleComponentA3 with: [
				spec repository: 'github://example/ComponentMain3/src' ];
			baseline: #GtRlBaselineExampleComponentB3Main with: [
				spec repository: 'github://example/ComponentMain3/src' ];
			baseline: #GtRlBaselineExampleComponentC3 with: [
				spec repository: 'github://example/ComponentC3/src' ].
	].
]
