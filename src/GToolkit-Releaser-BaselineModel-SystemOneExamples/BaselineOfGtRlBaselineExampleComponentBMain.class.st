Class {
	#name : #BaselineOfGtRlBaselineExampleComponentBMain,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemOneExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleComponentBMain >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: #GtRlBaselineExampleComponentBUtil with: [
			spec repository: 'github://example/ComponentB/src' ].
	].
]
