Class {
	#name : #GtRlPrintProjectVersionCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'GToolkit-Releaser-Support'
}

{ #category : #accessing }
GtRlPrintProjectVersionCommandLineHandler class >> commandName [
	^ 'printProjectVersion'
]

{ #category : #accessing }
GtRlPrintProjectVersionCommandLineHandler class >> description [
	^ 'Print a project version.'
]

{ #category : #testing }
GtRlPrintProjectVersionCommandLineHandler class >> isAbstract [
	^ self name = #GtRlPrintProjectVersionCommandLineHandler
]

{ #category : #activation }
GtRlPrintProjectVersionCommandLineHandler >> activate [
	self activateHelp ifTrue: [ ^ self ].

	self stdout
		nextPutAll: self projectVersionString asString;
		nextPutAll: OSPlatform current lineEnding;
		flush.

	self quit
]

{ #category : #'api - building' }
GtRlPrintProjectVersionCommandLineHandler >> postReleaseAction: workflow [
	"Extra actions after a successful release.
	It can be used to set project version, using 
	`GtImage projectVersion: workflow rootProjectRelease version`.
	Note, that the #projectVersion: method must be implemented by the project"

	
]

{ #category : #'api - building' }
GtRlPrintProjectVersionCommandLineHandler >> projectVersionString [
	"Return a project version."

	<return: #String>
	^ GtImage instance projectVersion
]
