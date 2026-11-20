"
Runs the full release examples through {{gtClass:GtRlChecksRunner}} for Jenkins. It waits for the workers, writes a JUnit report, and exits with failure when checks fail or the run cannot complete.
"
Class {
	#name : #GtRlParallelExamplesCommandLineHandler,
	#superclass : #GtReleaserDedicatedBranchExamplesCommandLineHandler,
	#category : #'GToolkit-Releaser-ChecksRunner'
}

{ #category : #accessing }
GtRlParallelExamplesCommandLineHandler class >> commandName [
	^ 'parallelReleaseBranchExamples'
]

{ #category : #running }
GtRlParallelExamplesCommandLineHandler >> activate [
	| runner failed deadline |
	self activateHelp ifTrue: [ ^ self ].
	self packagesToSkip asSet = GtRlChecksRunner defaultSkippedPackageNames asSet
		ifFalse: [ ^ self
				exitFailure: 'Parallel runner skip packages differ from the CI selection' ].
	(self hasOption: 'disable-deprecation-rewrites')
		ifTrue: [ Deprecation activateTransformations: false ].
	runner := GtRlChecksRunner ciExamples.
	deadline := DateAndTime now + 210 minutes.
	[ runner stats state = #finished
		or: [ runner ciInitializationFailed or: [ DateAndTime now >= deadline ] ] ]
		whileFalse: [ (Delay forSeconds: 1) wait ].
	runner ciInitializationFailed
		ifTrue: [ ^ self exitFailure: 'Parallel examples failed during initialization' ].
	runner stats state = #finished
		ifFalse: [ ^ self exitFailure: 'Parallel examples did not finish within 210 minutes' ].
	failed := self writeReportFor: runner.
	failed ifTrue: [ ^ self exitFailure: 'Parallel examples failed' ].
	^ self exitSuccess
]

{ #category : #reporting }
GtRlParallelExamplesCommandLineHandler >> writeJUnitCase: anAssociation on: stream [
	| name result tag message trace |
	name := anAssociation key.
	result := anAssociation value.
	stream
		nextPutAll: '<testcase classname="';
		nextPutAll: (self xmlEscape: name key);
		nextPutAll: '" name="';
		nextPutAll: (self xmlEscape: name value);
		nextPutAll: '">'.
	result
		ifNil: [ stream nextPutAll: '<error message="No result for example" />' ].
	result
		ifNotNil: [ result isSkipped ifTrue: [ stream nextPutAll: '<skipped />' ].
			(result isFailure or: [ result isError ])
				ifTrue: [ tag := result isFailure ifTrue: [ 'failure' ] ifFalse: [ 'error' ].
					message := result exceptionMessageText.
					trace := result exceptionTrace.
					stream
						nextPutAll: '<';
						nextPutAll: tag;
						nextPutAll: ' message="';
						nextPutAll: (self xmlEscape: message);
						nextPutAll: '">';
						nextPutAll: (self xmlEscape: trace);
						nextPutAll: '</';
						nextPutAll: tag;
						nextPutAll: '>' ] ].
	stream
		nextPutAll: '</testcase>';
		lf
]

{ #category : #reporting }
GtRlParallelExamplesCommandLineHandler >> writeJUnitFor: results on: stream [
	| failures errors skipped |
	failures := results
			count: [ :each | each value notNil and: [ each value isFailure ] ].
	errors := results
			count: [ :each | each value isNil or: [ each value isError ] ].
	skipped := results
			count: [ :each | each value notNil and: [ each value isSkipped ] ].
	stream
		nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>';
		lf.
	stream
		nextPutAll: '<testsuite name="Parallel examples" tests="';
		print: results size;
		nextPutAll: '" failures="';
		print: failures;
		nextPutAll: '" errors="';
		print: errors;
		nextPutAll: '" skipped="';
		print: skipped;
		nextPutAll: '">';
		lf.
	results do: [ :each | self writeJUnitCase: each on: stream ].
	stream
		nextPutAll: '</testsuite>';
		lf
]

{ #category : #reporting }
GtRlParallelExamplesCommandLineHandler >> writeReportFor: aRunner [
	| results file |
	results := aRunner ciResults.
	file := FileLocator workingDirectory / 'ParallelExamples.xml'.
	file writeStreamDo: [ :stream | self writeJUnitFor: results on: stream ].
	^ results
		anySatisfy: [ :each | each value isNil or: [ each value isFailure or: [ each value isError ] ] ]
]

{ #category : #reporting }
GtRlParallelExamplesCommandLineHandler >> xmlEscape: aString [
	^ GtExamplesBasicHudsonReport new encode: aString
]
