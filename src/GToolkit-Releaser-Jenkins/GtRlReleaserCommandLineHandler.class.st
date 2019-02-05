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
	self activateHelp
		ifTrue: [  ^ self ].
	self arguments size > 1 ifTrue: 
		[ self inform: 'Releaser has only one argument: the new version it should use. E.g.: v0.4.2'].
	TranscriptLogger runDuring: [ 
		self arguments isEmpty 
			ifTrue: [ GtRlReleaserExportWorkflow performGToolkitRelease ]
			ifFalse:[ | semanticVersion w | semanticVersion := (self argumentAt:1) asGtRlSemanticVersionNumber.
				w := GtRlReleaserExportWorkflow buildGToolkitRelease: semanticVersion.
				w executeReleaseActions. ].
	].
	Smalltalk snapshot: true andQuit: true.
]
