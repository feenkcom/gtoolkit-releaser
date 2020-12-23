"
I am a baseline that contains unknows nodes in package dependencies
"
Class {
	#name : #BaselineOfGtRlBaselineExampleWithUnknownNodes,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-StandaloneSystemsExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleWithUnknownNodes >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec package: 'PackageA' with: [ 
			spec requires: #('UnknowsNodeA') ].
		spec package: 'PackageB' with: [ 
			spec requires: #('UnknowsNodeA' 'UnknowsNodeB') ]
	].
]
