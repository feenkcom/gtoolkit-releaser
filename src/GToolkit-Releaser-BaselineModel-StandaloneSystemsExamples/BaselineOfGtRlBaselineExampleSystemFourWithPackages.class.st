"
I am a baseline with dependencies between packages


"
Class {
	#name : #BaselineOfGtRlBaselineExampleSystemFourWithPackages,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-StandaloneSystemsExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleSystemFourWithPackages >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec package: 'PackageAMain'.
		spec package: 'PackageB'.
		spec package: 'PackageB-Tests' with: [ 
			spec requires: #('PackageB') ].
		spec package: 'PackageA-Part1' with: [ 
			spec requires: #('PackageAMain') ].
		spec package: 'PackageA-Test' with: [ 
			spec requires: #('PackageA-Part1' 'PackageAMain') ].
	].
]
