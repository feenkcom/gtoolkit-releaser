Class {
	#name : #GtReleaserDedicatedBranchExamplesCommandLineHandler,
	#superclass : #GtExamplesCommandLineHandler,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtReleaserDedicatedBranchExamplesCommandLineHandler class >> commandName [
	^ 'dedicatedReleaseBranchExamples'
]

{ #category : #accessing }
GtReleaserDedicatedBranchExamplesCommandLineHandler >> packages [ 
	| baselineProject packages packageNames |
	
	baselineProject := BaselineOfGToolkit fullBaselineProject.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage |
		aPackage gtExamplesAllContained isNotEmpty ].
	
	packageNames := packages collect: [ :aPackage | aPackage name ].
	
	^ packageNames difference: self packagesToSkip
]
