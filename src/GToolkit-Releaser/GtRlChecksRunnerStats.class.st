Class {
	#name : #GtRlChecksRunnerStats,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'state',
		'total',
		'workerPassed',
		'inImagePassed',
		'uiProcessPassed',
		'skipped',
		'failure',
		'error',
		'warning',
		'startTime',
		'endTime',
		'announcer'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlChecksRunnerStats >> announcer [

	^ announcer
]

{ #category : #accessing }
GtRlChecksRunnerStats >> duration [

	(startTime isNil or: [ endTime isNil ]) ifTrue: [ ^ nil ].

	^ endTime - startTime
]

{ #category : #accessing }
GtRlChecksRunnerStats >> endTime [
	^ endTime
]

{ #category : #accessing }
GtRlChecksRunnerStats >> endTime: anObject [
	endTime := anObject
]

{ #category : #'as yet unclassified' }
GtRlChecksRunnerStats >> errorCount [

	^ error
]

{ #category : #accessing }
GtRlChecksRunnerStats >> failure [
	^ failure
]

{ #category : #accessing }
GtRlChecksRunnerStats >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: [ :item | item last ];
		  updateWhen: GtRlChecksRunnerUpdateAnnouncement in: announcer;
		  actionUpdateButton
]

{ #category : #accessing }
GtRlChecksRunnerStats >> inImagePassed [
	^ inImagePassed
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementError [

	error := error + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementFailure [

	failure := failure + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementInImagePassed [

	inImagePassed := inImagePassed + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementSkipped [

	skipped := skipped + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementUiProcessPassed [

	uiProcessPassed := uiProcessPassed + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementWarning [

	warning := warning + 1.
]

{ #category : #private }
GtRlChecksRunnerStats >> incrementWorkerPassed [

	workerPassed := workerPassed + 1.
]

{ #category : #initialization }
GtRlChecksRunnerStats >> initialize [

	super initialize.
	announcer := Announcer new.
	total := workerPassed := inImagePassed := uiProcessPassed := skipped := failure := error := warning := 0.
	state := #notStarted.
]

{ #category : #accessing }
GtRlChecksRunnerStats >> notCounted [

	^ total - workerPassed - inImagePassed - uiProcessPassed - skipped - failure - error - warning
]

{ #category : #ui }
GtRlChecksRunnerStats >> notifyUpdate [
	"Announce that the summary view should be updated"

	self announce: GtRlChecksRunnerUpdateAnnouncement new
]

{ #category : #accessing }
GtRlChecksRunnerStats >> skipped [
	^ skipped
]

{ #category : #accessing }
GtRlChecksRunnerStats >> startTime [
	^ startTime
]

{ #category : #accessing }
GtRlChecksRunnerStats >> startTime: anObject [
	startTime := anObject
]

{ #category : #accessing }
GtRlChecksRunnerStats >> state [
	<return: #Symbol>

	^ state
]

{ #category : #accessing }
GtRlChecksRunnerStats >> state: anObject [
	state := anObject
]

{ #category : #accessing }
GtRlChecksRunnerStats >> summaryAttributes [

	^ {
		{ 'State'. state. }.
		{ 'Start Time'. startTime. }.
		{ 'End Time'. endTime. }.
		{ 'Duration'. self duration. }.
		{ 'Worker Passed'. workerPassed. }.
		{ 'InImage Passed'. inImagePassed. }.
		{ 'UI Process Passed'. uiProcessPassed. }.
		{ 'Failure'. failure. }.
		{ 'Error'. error. }.
		{ 'Skipped'. skipped. }.
		{ 'Warning'. warning. }.
		{ 'Not Counted'. self notCounted. }.
		{ 'Total'. total. }.
		}
]

{ #category : #accessing }
GtRlChecksRunnerStats >> total [
	^ total
]

{ #category : #accessing }
GtRlChecksRunnerStats >> total: anObject [
	total := anObject
]

{ #category : #accessing }
GtRlChecksRunnerStats >> uiProcessPassed [
	^ uiProcessPassed
]

{ #category : #'as yet unclassified' }
GtRlChecksRunnerStats >> updateInImage: aTaskFinishedAnnouncement [
	| task |

		task := aTaskFinishedAnnouncement task.
		task result do: [ :result | | shortName |
			shortName := result shortName.
			shortName = #pass ifTrue: [ self incrementInImagePassed ] ].
]

{ #category : #'as yet unclassified' }
GtRlChecksRunnerStats >> updateUiProcess: aTaskFinishedAnnouncement [
	| task |

		task := aTaskFinishedAnnouncement task.
		task result do: [ :result | | shortName |
			shortName := result shortName.
			shortName = #pass ifTrue: [ self incrementUiProcessPassed ].
			shortName = #skip ifTrue: [ self error: 'Shouldn''t happen' ].
			shortName = #failure ifTrue: [ self incrementFailure ].
			shortName = #error ifTrue: [ self incrementError ].
			shortName = #warning ifTrue: [ self incrementWarning ] ].
]

{ #category : #'as yet unclassified' }
GtRlChecksRunnerStats >> updateWorker: aTaskFinishedAnnouncement [
	| task |

		task := aTaskFinishedAnnouncement task.
		task result do: [ :result | | shortName |
			shortName := result shortName.
			shortName = #pass ifTrue: [ self incrementWorkerPassed ].
			shortName = #skip ifTrue: [ self incrementSkipped ] ].
]

{ #category : #accessing }
GtRlChecksRunnerStats >> warning [
	^ warning
]

{ #category : #accessing }
GtRlChecksRunnerStats >> workerPassed [
	^ workerPassed
]
