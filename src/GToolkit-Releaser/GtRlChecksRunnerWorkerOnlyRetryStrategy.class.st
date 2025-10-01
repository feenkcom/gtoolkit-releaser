Class {
	#name : #GtRlChecksRunnerWorkerOnlyRetryStrategy,
	#superclass : #GtRlChecksRunnerRetryStrategy,
	#category : #'GToolkit-Releaser-ChecksRunner'
}

{ #category : #'event handling' }
GtRlChecksRunnerWorkerOnlyRetryStrategy >> inImageTaskCompleted: aTaskFinishedAnnouncement [

	self error: 'Unexpected event... checks should not be run in-image'.
]

{ #category : #'event handling' }
GtRlChecksRunnerWorkerOnlyRetryStrategy >> initialJobTaskCompleted: aTaskCompletedAnnouncement [

	rlRunner storeTaskResults: aTaskCompletedAnnouncement.
	rlRunner stats
		updateWorker: aTaskCompletedAnnouncement;
		updateFinal: aTaskCompletedAnnouncement.
]

{ #category : #'event handling' }
GtRlChecksRunnerWorkerOnlyRetryStrategy >> uiProcessTaskCompleted: aTaskFinishedAnnouncement [

	self error: 'Unexpected event... checks should not be run in-image'.
]
