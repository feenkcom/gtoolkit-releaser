Class {
	#name : #GtRlGlamorousToolkitLoaderLogExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlGlamorousToolkitLoaderLogExamples >> consolidatedBaselineEvent [
	<gtExample>
	| consolidatedEvent |
	consolidatedEvent := GtRlLoadedConsolidatedBaselineEvent readFromFile:  self logFile.
	
	self 
		assert: consolidatedEvent totalDuration 
		equals: (Duration seconds: 462 nanoSeconds: 153798000).
	
	^ consolidatedEvent
]

{ #category : #accessing }
GtRlGlamorousToolkitLoaderLogExamples >> logFile [
	^  FileLocator gtResource
		/ 'feenkcom/gtoolkit/doc/loader'
		/ 'loader-log-example.txt'
]
