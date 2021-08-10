Class {
	#name : #GtReleaserGetGToolkitVersionCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'GToolkit-Releaser-GToolkit-Releaser'
}

{ #category : #accessing }
GtReleaserGetGToolkitVersionCommandLineHandler class >> commandName [
	^ 'getgtoolkitversion'
]

{ #category : #accessing }
GtReleaserGetGToolkitVersionCommandLineHandler class >> description [
	^ 'A command to get the current version of gtoolkit from ', GtImage class name
]

{ #category : #accessing }
GtReleaserGetGToolkitVersionCommandLineHandler >> activate [
	self stdout
		nextPutAll: GtImage version versionString;
		nextPutAll: OSPlatform current lineEnding;
		flush.

	self quit
]
