Class {
	#name : #GtRlDedicatedBranchSlidesCommandLineHandler,
	#superclass : #GtReleaserDedicatedBranchExamplesCommandLineHandler,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler class >> checksLabel [
	^ 'Slide'
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler class >> commandName [
	^ 'dedicatedReleaseBranchSlides'
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler class >> description [
	^ 'A command line runner for slides'.
]

{ #category : #private }
GtRlDedicatedBranchSlidesCommandLineHandler >> exampleReport [
	"This need to be overriden to provide the runner for slides."
	
	(self hasOption: 'junit-xml-output') ifTrue: [ ^ GtSlidesHudsonReport ].
	^ self error: 'only works for now for junit for now'
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler >> packages [ 
	| baselineProject packages packageNames |
	
	baselineProject := BaselineOfGToolkit fullBaselineProject.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage |
		aPackage gtSlideBuildersAllContained isNotEmpty ].
	
	packageNames := packages collect: [ :aPackage | aPackage name ].
	
	^ packageNames difference: self packagesToSkip
]
