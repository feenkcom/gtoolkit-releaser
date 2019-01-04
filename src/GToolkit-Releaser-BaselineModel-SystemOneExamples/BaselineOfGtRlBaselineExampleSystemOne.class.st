Class {
	#name : #BaselineOfGtRlBaselineExampleSystemOne,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemOneExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemOne >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: #GtRlBaselineExampleComponentA with: [
				spec repository: 'github://example/ComponentA/src' ];
			baseline: #GtRlBaselineExampleComponentBMain with: [
				spec repository: 'github://example/ComponentB/src' ];
			baseline: #GtRlBaselineExampleComponentC with: [
				spec repository: 'github://example/ComponentC/src' ];
			baseline: #GtRlBaselineExampleComponentD with: [
				spec repository: 'github://example/ComponentD/src' ].
	].
]
