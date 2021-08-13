Class {
	#name : #GtReleaserBumpGToolkitVersionCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : 'GToolkit-Releaser-GToolkit-Releaser'
}

{ #category : #accessing }
GtReleaserBumpGToolkitVersionCommandLineHandler class >> commandName [
	^ 'bumpgtoolkitversion'
]

{ #category : #accessing }
GtReleaserBumpGToolkitVersionCommandLineHandler class >> description [
	^ 'A command to bump the version of gtoolkit using releaser'
]

{ #category : #accessing }
GtReleaserBumpGToolkitVersionCommandLineHandler >> activate [
	| theVersionComputation theWorkflowBuilder theWorkflow theVersion |
	
	theVersionComputation := self commandLine
		optionAt: 'strategy'
		ifPresent: [ :aStrategyName |
			GtRlSemanticVersionComputation named: aStrategyName ]
		ifAbsent: [ GtRlPatchVersionComputation new ].
	
	theWorkflowBuilder := [ GtRlReleaserExportWorkflow
		buildGToolkitReleaseWithVersionComputation: theVersionComputation ].
	
	theWorkflow := (self hasOption: 'verbose')
		ifTrue: [ TranscriptLogger runDuring: theWorkflowBuilder ]
		ifFalse: theWorkflowBuilder.
	
	theVersion := theWorkflow rootProjectRelease version.
	
	self stdout
		nextPutAll: theVersion versionString;
		nextPutAll: OSPlatform current lineEnding;
		flush.
	
	GtImage version: theVersion.
	GtImage timestamp: DateAndTime now.
	
	(self hasOption: 'save')
		ifTrue: [ 
			^ Smalltalk 
				snapshot: true 
				andQuit: (self hasOption: 'no-quit') not ].
	
	(self hasOption: 'no-quit')
		ifFalse: [ self quit ]
]
