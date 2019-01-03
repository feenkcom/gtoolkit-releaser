Class {
	#name : #BaselineOfGtRlBaselineExampleSystemTwo,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemTwoExamples'
}

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
