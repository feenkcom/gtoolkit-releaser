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
	^ 'Print a project version. Use --line-ending=false to print just version number.'
]

{ #category : #testing }
GtRlPrintProjectVersionCommandLineHandler class >> isAbstract [
	^ self name = #GtRlPrintProjectVersionCommandLineHandler
]

{ #category : #activation }
GtRlPrintProjectVersionCommandLineHandler >> activate [
	self activateHelp ifTrue: [ ^ self ].

	self stdout
		in: [ :aTranscript | 
			aTranscript nextPutAll: self projectVersionString asString.
			self lineEndingOption
				ifTrue: [ aTranscript nextPutAll: OSPlatform current lineEnding ].
			aTranscript flush ].

	self quit
]

{ #category : #'accessing - arguments' }
GtRlPrintProjectVersionCommandLineHandler >> lineEndingOption [
	"Define whether to print line ending.
	The command line option is written as: --line-ending=true"

	<return: #String>
	^ self commandLine
		optionAt: 'line-ending'
		ifPresent: [ :aValue | aValue = 'true' ]
		ifAbsent: [ false ]
]

{ #category : #'api - building' }
GtRlPrintProjectVersionCommandLineHandler >> projectVersionString [
	"Return a project version."

	<return: #String>
	^ GtImage instance projectVersion
		ifNotNil: #versionString
		ifNil: [ '<no version>' ]
]
