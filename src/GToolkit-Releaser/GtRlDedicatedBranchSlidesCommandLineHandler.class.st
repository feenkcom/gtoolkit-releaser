Class {
	#name : #GtRlDedicatedBranchSlidesCommandLineHandler,
	#superclass : #GtReleaserDedicatedBranchExamplesCommandLineHandler,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler class >> commandName [
	^ 'dedicatedReleaseBranchSlides'
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler class >> description [
	^ 'A command line runner for slides'.
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler >> packages [ 
	| baselineProject packages packageNames |
	
	baselineProject := BaselineOfGToolkitForPharo9 gtRlProjectWithRepository: 'github://feenkcom/gtoolkit:main/src'.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage |
		aPackage gtSlideBuildersAllContained isNotEmpty ].
	
	packageNames := packages collect: [ :aPackage | aPackage name ].
	
	^ packageNames difference: self packagesToSkip
]
