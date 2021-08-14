Class {
	#name : 'GtReleaserNextGToolkitVersionCommandLineHandler',
	#superclass : 'CommandLineHandler',
	#category : 'GToolkit-Releaser-GToolkit-Releaser'
}

{ #category : 'accessing' }
GtReleaserNextGToolkitVersionCommandLineHandler class >> commandName [
	^ 'nextgtoolkitversion'
]

{ #category : 'accessing' }
GtReleaserNextGToolkitVersionCommandLineHandler class >> description [
	^ 'A command to compute the next version of gtoolkit using releaser'
]

{ #category : 'accessing' }
GtReleaserNextGToolkitVersionCommandLineHandler >> activate [
	| theVersionComputation theNextVersion |
	
	theVersionComputation := self commandLine
		optionAt: 'strategy'
		ifPresent: [ :aStrategyName |
			GtRlSemanticVersionComputation named: aStrategyName ]
		ifAbsent: [ GtRlPatchVersionComputation new ].
	
	theNextVersion := GtImage computeNextGToolkitVersion: theVersionComputation.
	
	self stdout
		nextPutAll: theNextVersion versionString;
		nextPutAll: OSPlatform current lineEnding;
		flush.

	self quit
]
