Class {
	#name : #GtRlReleaserCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'GToolkit-Releaser-Jenkins'
}

{ #category : #accessing }
GtRlReleaserCommandLineHandler class >> commandName [
	^ 'releasegtoolkit'
]

{ #category : #accessing }
GtRlReleaserCommandLineHandler class >> description [
	^ 'GtRlReleaserCommand line utility'
]

{ #category : #activation }
GtRlReleaserCommandLineHandler >> activate [
	| theWorkflowBuilder theVersionComputation |
	
	self activateHelp
		ifTrue: [  ^ self ].
	
	theVersionComputation := self commandLine
		optionAt: 'strategy'
		ifPresent: [ :aStrategyName |
			GtRlSemanticVersionComputation named: aStrategyName ]
		ifAbsent: [ GtRlPatchVersionComputation new ].

	theWorkflowBuilder := [
		GtPharoCompletionStrategy unsubscribeFromSystem.
		(GtRlReleaserExportWorkflow buildGToolkitReleaseWithVersionComputation: theVersionComputation)
			executeReleaseActions.
		GtPharoCompletionStrategy subscribeToSystem ].

	(self hasOption: 'verbose')
		ifTrue: [ TranscriptLogger runDuring: theWorkflowBuilder ]
		ifFalse: theWorkflowBuilder.

	(self hasOption: 'save')
		ifTrue: [ 
			^ Smalltalk 
				snapshot: true 
				andQuit: (self hasOption: 'no-quit') not ].

	(self hasOption: 'no-quit')
		ifFalse: [ self quit ]
]
