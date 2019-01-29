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
	self arguments isEmpty 
		ifTrue: [ | w |
			w := GtRlReleaserExportWorkflow buildGToolkitRelease.
			w releaseCreationActions execute]
		ifFalse:[ | semanticVersion | semanticVersion := (self argumentAt:1) asGtRlSemanticVersionNumber.
			GtRlReleaserExportWorkflow buildGToolkitRelease: semanticVersion].
	self quit.
]
