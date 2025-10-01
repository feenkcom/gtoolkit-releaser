Class {
	#name : #GtRlChecksRunnerStats,
	#superclass : #Object,
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
		'announcer',
		'rlRunner'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #announcer }
GtRlChecksRunnerStats >> announce: anAnnouncement [

	^ self announcer announce: anAnnouncement
]

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

{ #category : #ui }
GtRlChecksRunnerStats >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: [ :item | item last value ];
		  updateWhen: GtRlChecksRunnerUpdateAnnouncement in: announcer;
		  actionUpdateButton
]

{ #category : #announcer }
GtRlChecksRunnerStats >> hasSubscriber: anObject [

	^ self announcer hasSubscriber: anObject
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

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"

	^ self announcer removeSubscription: subscription
]

{ #category : #accessing }
GtRlChecksRunnerStats >> rlRunner [
	^ rlRunner
]

{ #category : #accessing }
GtRlChecksRunnerStats >> rlRunner: anObject [
	rlRunner := anObject
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
		{ 'Duration'. self duration ifNil:
			[ startTime ifNotNil: [ :theStartTime | 
				'{1}+' format: { (DateAndTime now - theStartTime) gtShortPrintString } ] ]. }.
		{ 'Worker Passed'. workerPassed. }.
		{ 'InImage Passed'. inImagePassed. [ rlRunner successfulWorkerInImageResults ]. }.
		{ 'UI Process Passed'. uiProcessPassed. [ rlRunner successfulUiResults ]. }.
		{ 'Failure'. 
			failure > 0
				ifTrue: [ failure asString asRopedText foreground: BrGlamorousColors failureBackgroundColor ]
				ifFalse: [ failure ].
			[ rlRunner failureResults ]. }.
		{ 'Error'. 
			error > 0
				ifTrue: [ error asString asRopedText foreground: BrGlamorousColors errorBackgroundColor ]
				ifFalse: [ error ].
			[ rlRunner errorResults ]. }.
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

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	^ self announcer unsubscribe: anObject
]

{ #category : #'as yet unclassified' }
GtRlChecksRunnerStats >> updateInImage: aTaskFinishedAnnouncement [
	| task |

	task := aTaskFinishedAnnouncement task.
	task result do: [ :result | | shortName |
		shortName := result shortName.
		shortName = #pass ifTrue: [ self incrementInImagePassed ] ].
	self notifyUpdate.
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
	self notifyUpdate.
]

{ #category : #accessing }
GtRlChecksRunnerStats >> warning [
	^ warning
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> weak [
	"announcer weak subscribe: foo"

	^ self announcer weak
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that ushc method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."

		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer 
		when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"

	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"

		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
GtRlChecksRunnerStats >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber.
]

{ #category : #accessing }
GtRlChecksRunnerStats >> workerPassed [
	^ workerPassed
]
