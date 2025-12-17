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
		'rlRunner',
		'taskRetryStrategy'
	],
	#category : #'GToolkit-Releaser-ChecksRunner'
}

{ #category : #configuration }
GtRlChecksRunnerRetryStrategy >> configureInitialJob: aGtRrJob [

	taskRetryStrategy ifNotNil:
		[ aGtRrJob tasks do: [ :task |
			task retryStrategy: taskRetryStrategy copy ] ].
]

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

{ #category : #initialization }
GtRlChecksRunnerRetryStrategy >> initialize [

	super initialize.
	taskRetryStrategy := GtRrTaskTestRetry new.
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> rlRunner [
	^ rlRunner
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> rlRunner: anObject [
	rlRunner := anObject
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> taskRetryStrategy [
	<return: #GtRrTaskRetry>

	^ taskRetryStrategy
]

{ #category : #accessing }
GtRlChecksRunnerRetryStrategy >> taskRetryStrategy: aGtRrTaskRetry [
	"Set the retry strategy used by the headless GtRemoteRunner"

	taskRetryStrategy := aGtRrTaskRetry
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
