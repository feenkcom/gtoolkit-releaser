Class {
	#name : #BaselineOfGtRlBaselineExampleComponentD,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemOneExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleComponentD >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: #GtRlBaselineExampleComponentDModuleA with: [
			spec repository: 'github://example/ComponentDModuleA/src' ].
	].
]
