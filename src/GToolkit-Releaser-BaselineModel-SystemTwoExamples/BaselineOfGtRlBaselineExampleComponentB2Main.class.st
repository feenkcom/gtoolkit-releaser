Class {
	#name : 'BaselineOfGtRlBaselineExampleComponentB2Main',
	#superclass : 'BaselineOf',
	#category : 'GToolkit-Releaser-BaselineModel-SystemTwoExamples'
}

{ #category : 'baselines' }
BaselineOfGtRlBaselineExampleComponentB2Main >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: #GtRlBaselineExampleComponentB2Util with: [
			spec repository: 'github://example/SystemTwo/src' ].
	].
]
