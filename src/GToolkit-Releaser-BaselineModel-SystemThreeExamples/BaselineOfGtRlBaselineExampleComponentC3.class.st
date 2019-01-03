Class {
	#name : #BaselineOfGtRlBaselineExampleComponentC3,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemThreeExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleComponentC3 >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: #GtRlBaselineExampleComponentA3 with: [
			spec repository: 'github://example/ComponentMain3/src' ].
	].
]
