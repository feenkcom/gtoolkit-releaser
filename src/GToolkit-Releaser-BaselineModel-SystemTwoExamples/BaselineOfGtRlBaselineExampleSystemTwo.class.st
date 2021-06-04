"
I am a baseline having multiple dependencies where all baselines are placed within the same repository. I am used in examples for GtReleaser.

The dependencies between baselines are shown in the figure below.
{{gtExample:BaselineOfGtRlBaselineExampleSystemTwo class>>#itself|previewShow=#gtMapFor:|noCode}}


"
Class {
	#name : #BaselineOfGtRlBaselineExampleSystemTwo,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemTwoExamples'
}

{ #category : #accessing }
BaselineOfGtRlBaselineExampleSystemTwo class >> itself [
	<gtExample>
	^ self
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemTwo >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: #GtRlBaselineExampleComponentA2 with: [
				spec repository: 'github://example/SystemTwo/src' ];
			baseline: #GtRlBaselineExampleComponentB2Main with: [
				spec repository: 'github://example/SystemTwo/src' ];
			baseline: #GtRlBaselineExampleComponentC2 with: [
				spec repository: 'github://example/SystemTwo/src' ].
	].
]
