"
Examples for the Jenkins parallel example selection. They verify that {{gtClass:GtRlChecksRunner}} uses the dedicated release branch suite without the local pre-commit exclusions.
"
Class {
	#name : #GtRlChecksRunnerCiExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-ChecksRunner-Examples'
}

{ #category : #examples }
GtRlChecksRunnerCiExamples >> ciFactoryUsesFullReleaseSelection [
	<gtExample>
	| factory releaseNames ciNames |
	factory := GtRlChecksRunner ciExamplesFactory.
	releaseNames := GtRlChecksRunner dedicatedReleaseBranchExamplesFactory tasks
			flatCollect: #checkNames.
	ciNames := factory tasks flatCollect: #checkNames.
	self assert: ciNames asSet equals: releaseNames asSet.
	self assert: ciNames isNotEmpty.
	^ factory
]

{ #category : #examples }
GtRlChecksRunnerCiExamples >> ciRunnerLimitsHeadlessWorkers [
	<gtExample>
	| runner |
	runner := GtRlChecksRunner ciExamplesRunner.
	self
		assert: (runner workerRunner managerStartupAndShutdown poolSize > 0)
		description: [ 'Worker runner pool size is: {1}'
				format: {runner workerRunner managerStartupAndShutdown poolSize} ].
	^ runner
]

{ #category : #examples }
GtRlChecksRunnerCiExamples >> initializationFailureIsDetected [
	<gtExample>
	| runner process |
	runner := GtRlChecksRunner new.
	self assert: runner ciInitializationFailed not.
	process := [  ] fork.
	[ process isTerminated ] whileFalse: [ (Delay forMilliseconds: 1) wait ].
	runner instVarNamed: #initialisationProcess put: process.
	self assert: runner ciInitializationFailed.
	runner stats state: #running.
	self assert: runner ciInitializationFailed not.
	^ runner
]

{ #category : #examples }
GtRlChecksRunnerCiExamples >> junitReportForAllOutcomes [
	<gtExample>
	| handler passing failing error skipped results xml document |
	handler := GtRlParallelExamplesCommandLineHandler new.
	passing := PharoLinkTestCasePass new
			initializeTestCaseClassName: 'PassingExamples' selector: #passes;
			yourself.
	failing := PharoLinkTestCaseFailure new
			initializeTestCaseClassName: 'FailingExamples' selector: #fails;
			initializeExceptionClass: AssertionFailure
				messageText: 'bad <value>'
				trace: 'trace & detail';
			yourself.
	error := PharoLinkTestCaseError new
			initializeTestCaseClassName: 'ErrorExamples' selector: #errors;
			initializeExceptionClass: Error
				messageText: 'boom'
				trace: 'stack';
			yourself.
	skipped := PharoLinkTestCaseSkip new
			initializeTestCaseClassName: 'SkippedExamples' selector: #skips;
			yourself.
	results := {#PassingExamples -> #passes -> passing.
			#FailingExamples -> #fails -> failing.
			#ErrorExamples -> #errors -> error.
			#SkippedExamples -> #skips -> skipped.
			#MissingExamples -> #missing -> nil}.
	xml := String
			streamContents: [ :stream | handler writeJUnitFor: results on: stream ].
	document := XMLDOMParser parse: xml.
	self
		assert: (xml includesSubstring: 'tests="5" failures="1" errors="2" skipped="1"').
	self assert: (xml includesSubstring: 'bad &lt;value>').
	self assert: document notNil.
	^ document
]
