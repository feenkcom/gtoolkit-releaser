"
I am a baseline that has pre and post actions
"
Class {
	#name : #BaselineOfGtRlBaselineExampleStandaloneWithActions,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-StandaloneSystemsExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec preLoadDoIt: #'preloadAction:'.
		spec postLoadDoIt: #'postloadAction:'.
	].
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> postloadAction: loader [
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> preloadAction: loader [
]
