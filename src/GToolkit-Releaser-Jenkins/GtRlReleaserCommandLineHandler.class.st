Class {
	#name : 'GtRlReleaserCommandLineHandler',
	#superclass : 'CommandLineHandler',
	#category : 'GToolkit-Releaser-Jenkins'
}

{ #category : 'accessing' }
GtRlReleaserCommandLineHandler class >> commandName [
	^ 'releasegtoolkit'
]

{ #category : 'accessing' }
GtRlReleaserCommandLineHandler class >> description [
	^ 'GtRlReleaserCommand line utility'
]

{ #category : 'activation' }
GtRlReleaserCommandLineHandler >> activate [
	| theWorkflowBuilder theVersionComputation |
	
	self activateHelp
		ifTrue: [  ^ self ].
		
	self assignSshKeys.
	
	theVersionComputation := self commandLine
		optionAt: 'strategy'
		ifPresent: [ :aStrategyName |
			GtRlSemanticVersionComputation named: aStrategyName ]
		ifAbsent: [ GtRlPatchVersionComputation new ].

	theWorkflowBuilder := [
		| theWorkflow |
		GtPharoCompletionStrategy unsubscribeFromSystem.
		theWorkflow := GtRlReleaserExportWorkflow buildGToolkitReleaseWithVersionComputation: theVersionComputation.
		
		self commandLine
			optionAt: 'expected'
			ifPresent: [ :anExpectedVersionString |
				| anExpectedVersion anActualVersion |
				
				anExpectedVersion := GtRlSemanticVersionNumber readFromString: anExpectedVersionString.
				anActualVersion := theWorkflow rootProjectRelease version.
				
				anExpectedVersion ~= anActualVersion
					ifTrue: [ Error signal: ('Expected version {1} does not match the actual {2}'
						format: {
							anExpectedVersion versionString.
							anActualVersion versionString }) ] ].
		
		theWorkflow executeReleaseActions.
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

{ #category : 'accessing' }
GtRlReleaserCommandLineHandler >> assignSshKeys [
	| privateKey publicKey |
	
	privateKey := self
		optionAt: 'private-key'
		ifPresent: [ :aKeyPath | aKeyPath trim trimBoth: [ :char | #($' $") includes: char ] ]
		ifAbsent: nil.
	
	publicKey := self
		optionAt: 'public-key'
		ifPresent: [ :aKeyPath | aKeyPath trim trimBoth: [ :char | #($' $") includes: char ] ]
		ifAbsent: nil.
	
	((privateKey isNil and: [ publicKey notNil ])
		or: [ privateKey notNil and: [ publicKey isNil ] ])
			ifTrue: [ Error signal: 'Must specify both private and public key' ].
	
	(privateKey isNil and: [ publicKey isNil ])
		ifTrue: [ ^ self ].
	
	IceCredentialsProvider useCustomSsh: true.
	IceCredentialsProvider sshCredentials
		publicKey: publicKey;
		privateKey: privateKey
]
