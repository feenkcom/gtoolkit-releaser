Class {
	#name : 'GtReleaserDedicatedBranchExamplesCommandLineHandler',
	#superclass : 'GtExamplesCommandLineHandler',
	#category : 'GToolkit-Releaser'
}

{ #category : 'accessing' }
GtReleaserDedicatedBranchExamplesCommandLineHandler class >> commandName [
	^ 'dedicatedReleaseBranchExamples'
]

{ #category : 'accessing' }
GtReleaserDedicatedBranchExamplesCommandLineHandler >> packages [ 
	|packages|
	packages := GtRlReleaserExportWorkflow allExamplePackagesInDedicatedReleaseRepositories collect: [:p | p name].
	"packages := packages \ { #'Brick-Examples'}."
	^ packages
]
