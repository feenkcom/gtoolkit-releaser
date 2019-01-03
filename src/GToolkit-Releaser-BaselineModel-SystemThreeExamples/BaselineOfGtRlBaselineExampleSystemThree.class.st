Class {
	#name : #BaselineOfGtRlBaselineExampleSystemThree,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemThreeExamples'
}

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
