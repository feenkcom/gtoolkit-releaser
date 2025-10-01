"
GtRlChecksRunnerRetryStrategy implements the original default behaviour of:

1. Run all examples in the headless workers (without any retry).
2. Run failing examples in the in-image worker.
3 Run failing examples in the UI process.
"
Class {
	#name : #GtRlChecksRunnerRetryStrategy,
	#superclass : #Object,
	#instVars : [
		'rlRunner'
	],
	#category : #'GToolkit-Releaser-ChecksRunner'
}

{ #category : #'event handling' }
GtRlChecksRunnerRetryStrategy >> inImageTaskCompleted: aTaskFinishedAnnouncement [

	rlRunner storeTaskResults: aTaskFinishedAnnouncement.
	rlRunner runUiProcessFailures: aTaskFinishedAnnouncement.
	rlRunner stats updateInImage: aTaskFinishedAnnouncement.
]

{ #category : #'event handling' }
GtRlChecksRunnerRetryStrategy >> initialJobTaskCompleted: aTaskCompletedAnnouncement [

	rlRunner storeTaskResults: aTaskCompletedAnnouncement.
	rlRunner submitInImageRetries: aTaskCompletedAnnouncement.
	rlRunner stats updateWorker: aTaskCompletedAnnouncement.
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> rlRunner [
	^ rlRunner
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> rlRunner: anObject [
	rlRunner := anObject
]

{ #category : #'event handling' }
GtRlChecksRunnerRetryStrategy >> uiProcessTaskCompleted: aTaskFinishedAnnouncement [

	[ | task |
	task := aTaskFinishedAnnouncement task.
	task result do: [ :result |
		rlRunner storeCheckResult: result.
		rlRunner storeCheckFailure: result. ] ]
			forkNamed: self class name asString, ' runTaskFailures store results'.
	rlRunner stats 
		updateUiProcess: aTaskFinishedAnnouncement;
		updateFinal: aTaskFinishedAnnouncement.
]
