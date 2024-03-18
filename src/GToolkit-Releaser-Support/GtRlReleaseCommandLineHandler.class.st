Class {
	#name : #GtRlReleaseCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'GToolkit-Releaser-Support'
}

{ #category : #accessing }
GtRlReleaseCommandLineHandler class >> commandName [
	^ 'releaseProject'
]

{ #category : #accessing }
GtRlReleaseCommandLineHandler class >> description [
	^ 'Release project line utility. 
	Options:
		--version=<version> enforce a release version, usage: --version=v1.4.22
		--release=<true|false> proceed a release action, usage: --release=true
		--commits=<true|false> print new commits to newcommits<index>.txt files, usage: --commits=true'
]

{ #category : #testing }
GtRlReleaseCommandLineHandler class >> isAbstract [
	^ self name = #GtRlReleaseCommandLineHandler
]

{ #category : #activation }
GtRlReleaseCommandLineHandler >> activate [
	self activateHelp ifTrue: [ ^ self ].

	TranscriptLogger
		runDuring: [ | releaseExporter |
			releaseExporter := self newReleaseExporter.
			self preReleaseAction: releaseExporter.

			self versionOption ifNotNil: [ :aVersion | 
				| semanticVersion |
				semanticVersion := self versionOption asGtRlSemanticVersionNumber.
				releaseExporter forceNewRelease.
				releaseExporter enforcedVersion: semanticVersion ].

			self commitsOption ifTrue: [ 
				releaseExporter printNewCommitsToFile ].

			self releaseOption ifTrue: [ 
				| workflow |
				workflow := releaseExporter buildReleaseWorkflow.
				workflow executeReleaseActions.
				self postReleaseAction: workflow ] ].

	Smalltalk snapshot: true andQuit: true
]

{ #category : #'accessing - arguments' }
GtRlReleaseCommandLineHandler >> commitsOption [
	"Define whether to print commit versions.
	The command line option is written as: --commits=true"

	<return: #String>
	^ self commandLine
		optionAt: 'commits'
		ifPresent: [ :aValue | aValue = 'true' ]
		ifAbsent: [ false ]
]

{ #category : #initialization }
GtRlReleaseCommandLineHandler >> newReleaseExporter [
	"Command line handler subclasses must properly initialize the release exporter."

	^ GtRlReleaseExporter new
]

{ #category : #hooks }
GtRlReleaseCommandLineHandler >> postReleaseAction: aWorkflow [
	"Extra actions after a successful release.
	It can be used to set project version, using 
	`GtImage instance project: 'Project Name' version: workflow rootProjectRelease version`.
	You can implement similar yourProjectVersion method."

	
]

{ #category : #hooks }
GtRlReleaseCommandLineHandler >> preReleaseAction: aReleaseExporter [
	"Extra actions before a release."

	
]

{ #category : #'accessing - arguments' }
GtRlReleaseCommandLineHandler >> releaseOption [
	"Define whether to proceed a release.
	The command line option is written as: --release=true"

	<return: #String>
	^ self commandLine
		optionAt: 'release'
		ifPresent: [ :aValue | aValue = 'true' ]
		ifAbsent: [ false ]
]

{ #category : #'accessing - arguments' }
GtRlReleaseCommandLineHandler >> versionOption [
	"Return new version value, e.g., v0.4.2.
	The command line option is written as: --version=v0.4.2"

	<return: #String>
	^ self commandLine optionAt: 'version' ifAbsent: [ nil ]
]
