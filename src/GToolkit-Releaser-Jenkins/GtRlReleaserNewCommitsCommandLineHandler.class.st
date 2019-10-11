Class {
	#name : #GtRlReleaserNewCommitsCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'GToolkit-Releaser-Jenkins'
}

{ #category : #accessing }
GtRlReleaserNewCommitsCommandLineHandler class >> commandName [
	^ 'printNewCommits'
]

{ #category : #accessing }
GtRlReleaserNewCommitsCommandLineHandler class >> description [
	^ 'GtRlReleaserCommand new commits printer'
]

{ #category : #activation }
GtRlReleaserNewCommitsCommandLineHandler >> activate [
	self activateHelp
		ifTrue: [  ^ self ].
	self arguments isEmpty ifTrue: 
		[ self inform: 'Commits printer does not have arguments.'].
	TranscriptLogger runDuring: [ 
				|workflow|
				workflow := GtRlReleaserExportWorkflow buildGToolkitRelease.
				workflow printNewCommitsToFile.
	].
	Smalltalk snapshot: true andQuit: true.
]
