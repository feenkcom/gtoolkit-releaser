Class {
	#name : #GtRlDedicatedBranchSlidesCommandLineHandler,
	#superclass : #GtReleaserDedicatedBranchExamplesCommandLineHandler,
	#category : 'GToolkit-Releaser'
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
GtRlDedicatedBranchSlidesCommandLineHandler >> exampleReport [
	(self hasOption: 'junit-xml-output') ifTrue: [ ^ GtSlidesHudsonReport ].
	^ self error: 'only works for now for junit for now'
]

{ #category : #accessing }
GtRlDedicatedBranchSlidesCommandLineHandler >> packages [ 
	^ GtRlReleaserExportWorkflow allSlidesPackagesInDedicatedReleaseRepositories 
			collect: #name.
]
