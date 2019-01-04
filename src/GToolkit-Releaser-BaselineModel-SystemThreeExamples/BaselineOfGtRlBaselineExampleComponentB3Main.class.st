Class {
	#name : #BaselineOfGtRlBaselineExampleComponentB3Main,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemThreeExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleComponentB3Main >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: #GtRlBaselineExampleComponentA3 with: [
			spec repository: 'github://example/ComponentMain3/src' ].
	].
]
