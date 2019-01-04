Class {
	#name : #GtRlReleaseConfigurationSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'configuration'
	],
	#category : #'GToolkit-Releaser-Beacon'
}

{ #category : #'instance creation' }
GtRlReleaseConfigurationSignal class >> emit: aReleaseConfiguration [
	"comment stating purpose of message"
	^ self new 
		configuration: aReleaseConfiguration;
		emit.
]

{ #category : #accessing }
GtRlReleaseConfigurationSignal >> configuration: aReleaseConfiguration [
	configuration := aReleaseConfiguration 
]

{ #category : #accessing }
GtRlReleaseConfigurationSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: configuration defaultReleaseBranchName; nextPutAll:' '; nextPutAll:configuration defaultReleaseStrategy class name; nextPutAll:' '; nextPutAll: configuration defaultVersionComputation class name 
]
