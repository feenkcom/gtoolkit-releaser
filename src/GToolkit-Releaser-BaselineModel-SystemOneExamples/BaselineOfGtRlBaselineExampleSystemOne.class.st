"
I am a baseline in which there is a single dependency to every child baseline. I am used in examples for GtReleaser.

The dependencies between baselines are shown in the figure below.
{{gtExample:BaselineOfGtRlBaselineExampleSystemOne class>>#itself|previewShow=#gtMapFor:|noCode}}


"
Class {
	#name : #BaselineOfGtRlBaselineExampleSystemOne,
	#superclass : #BaselineOf,
	#category : 'GToolkit-Releaser-BaselineModel-SystemOneExamples'
}

{ #category : #accessing }
BaselineOfGtRlBaselineExampleSystemOne class >> itself [
	<gtExample>
	^ self
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemOne >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GtRlBaselineExampleComponentA' with: [
				spec repository: 'github://example/ComponentA/src' ].
		spec
			baseline: 'GtRlBaselineExampleComponentBMain' with: [
				spec repository: 'github://example/ComponentB/src' ].
		spec
			baseline: 'GtRlBaselineExampleComponentC' with: [
				spec repository: 'github://example/ComponentC/src' ].
		spec
			baseline: 'GtRlBaselineExampleComponentD' with: [
				spec repository: 'github://example/ComponentD/src' ].
	]
]
