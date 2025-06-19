Class {
	#name : #GtRlChecksRunner,
	#superclass : #Object,
	#instVars : [
		'sharedAccess',
		'workerRunner',
		'inImageRunner',
		'jobs',
		'times',
		'taskResults',
		'checkResults',
		'checkFailures',
		'checkSkips',
		'enqueueSubmitCount',
		'enqueueRunCount',
		'stats'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlChecksRunner class >> checksFactory: aGtRrChecksFactory [
	"Run the examples in the supplied factory"
	| checksRunner initialJob |

	"Start the runner first so the default GtRrCheckSchedulingTimes is available"
	checksRunner := self new.
	checksRunner startRunners.	"Generate and submit the job"
	aGtRrChecksFactory groupTasksByTime.
	initialJob := aGtRrChecksFactory job.
	initialJob taskTimeout: 5 minutes.
	checksRunner initialJob: initialJob.
	^ checksRunner
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> dedicatedReleaseBranchExamples [
	"Run the dedicated release branch examples"

	^ self checksFactory: self dedicatedReleaseBranchExamplesFactory.
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> dedicatedReleaseBranchExamplesFactory [
	"Answer a GtRrChecksFactory with the dedicatedReleaseBranch examples"
	| examples baselineProject packages allPackageNames factory |

	baselineProject := BaselineOfGToolkit fullBaselineProject.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage | 
		aPackage gtExamplesAllContained isNotEmpty ].

	allPackageNames := packages collect: [ :aPackage | aPackage name ].
	allPackageNames := allPackageNames difference: self defaultSkippedPackageNames.

	allPackageNames := allPackageNames first: 100.

	examples := allPackageNames flatCollect: [ :pName | 
		(RPackage organizer packageNamed: pName) gtExamplesAllContained ].

	factory := GtRrChecksFactory new.
	factory addExampleTestNames: 
		(examples collect: [ :each | each providerClass name -> each selector ]).
	^ factory
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> defaultSkippedPackageNames [
	^ #(
	'GToolkit-Boxer' 
	'Sparta-Cairo' 
	'Sparta-Skia' 
	'GToolkit-RemoteExamples-GemStone' 
	'PythonBridge-Pharo'
	'GToolkit-Pharo-Coder-Examples'
	)
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> remoteRunnerExamples [
	"Run the RemoteRunner examples"

	^ self checksFactory: self remoteRunnerFactory
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> remoteRunnerFactory [
	"Answer a GtRrChecksFactory with the dedicatedReleaseBranch examples"
	| allPackageNames factory examples |
	
	allPackageNames := #('RemoteRunner').
	allPackageNames := allPackageNames difference: self defaultSkippedPackageNames.

	examples := allPackageNames flatCollect: [ :pName | 
		(RPackage organizer packageNamed: pName) gtExamplesAllContained ].

	factory := GtRrChecksFactory new.
	factory addExampleTestNames: 
		(examples collect: [ :each | each providerClass name -> each selector ]).
	^ factory
]

{ #category : #accessing }
GtRlChecksRunner >> completedTasks [

	^ jobs flatCollect: #tasks
]

{ #category : #private }
GtRlChecksRunner >> critical: aBlock [

	^ sharedAccess critical: aBlock
]

{ #category : #accessing }
GtRlChecksRunner >> errorResults [

	^ self critical:
		[ (checkFailures collect: #last as: Array)
			select: [ :each | each isError ] ].
]

{ #category : #accessing }
GtRlChecksRunner >> failureResults [

	^ self critical:
		[ (checkFailures collect: #last as: Array)
			select: [ :each | each isFailure ] ].
]

{ #category : #accessing }
GtRlChecksRunner >> failuresByPackage [
	| dict |
	dict := self critical:
		[ checkFailures keys groupedBy: [ :assoc |
			(self class environment classOrTraitNamed: assoc key) package ] ].

	"Replace array of associations with array of results?"

	^ dict.
]

{ #category : #private }
GtRlChecksRunner >> finishUp [
	stats
		state: #finished;
		endTime: DateAndTime now.
	self updateCheckTimes.
	self stopRunners.
]

{ #category : #ui }
GtRlChecksRunner >> gtErrorsFor: aView [
	<gtView>

	^ aView list
		title: 'Errors';
		priority: 21;
		items: [ self errorResults ];
		actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtFailuresByPackageFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Failures by package';
		priority: 40;
		items: [ self failuresByPackage associations
			sorted: #name ascending ];
		column: 'Package' text: [ :item | item key ];
		column: 'Number' text: [ :item | item value size ];
		send: [ :item | item value collect: [ :each |
			checkResults at: each ] ];
		actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtFailuresFor: aView [
	<gtView>

	^ aView list
		title: 'Failures';
		priority: 20;
		items: [ self failureResults ];
		actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtRunInImageSuccessesFor: aView [
	<gtView>

	^ aView list
		title: 'Run In-Image';
		priority: 31;
		items: [ self successfulRunInImageResults ];
		actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtRunningJobsFor: aView [
	<gtView>

	^ aView list
		title: 'Running Jobs';
		priority: 40;
		items: [ jobs reject: #isFinished ];
		actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtSummaryFor: aView [
	<gtView>

	^ aView forward
		  title: 'Summary';
		  priority: 10;
		  object: [ stats ];
		  view: #gtSummaryFor:;
		  actionUpdateButton
]

{ #category : #ui }
GtRlChecksRunner >> gtWorkerInImageSuccessesFor: aView [
	<gtView>

	^ aView list
		title: 'Worker In-Image';
		priority: 30;
		items: [ self successfulWorkerInImageResults ];
		actionUpdateButton
]

{ #category : #private }
GtRlChecksRunner >> inImageTaskCompleted: aTaskFinishedAnnouncement [

	self storeTaskResults: aTaskFinishedAnnouncement.
	self runTaskFailures: aTaskFinishedAnnouncement.
	stats updateInImage: aTaskFinishedAnnouncement.
]

{ #category : #accessing }
GtRlChecksRunner >> initialJob [

	^ jobs first
]

{ #category : #running }
GtRlChecksRunner >> initialJob: aGtRrChecksJob [
	self assert: jobs isEmpty description: 'Job already submitted'.
	self startInitialJob: aGtRrChecksJob
]

{ #category : #private }
GtRlChecksRunner >> initialJobTaskCompleted: aTaskCompletedAnnouncement [

	self storeTaskResults: aTaskCompletedAnnouncement.
	self submitRetries: aTaskCompletedAnnouncement.
	stats updateWorker: aTaskCompletedAnnouncement.
]

{ #category : #initialization }
GtRlChecksRunner >> initialize [

	super initialize.
	sharedAccess := Mutex new.
	jobs := OrderedCollection new.
	taskResults := OrderedCollection new.
	checkResults := Dictionary new.
	checkFailures := Dictionary new.
	checkSkips := Dictionary new.
	stats := GtRlChecksRunnerStats new.
]

{ #category : #private }
GtRlChecksRunner >> jobCompleted: aJobCompletedAnnouncement [
	| allFinished |
	self critical: 
		[ allFinished := jobs last isFinished
			ifTrue: [ jobs allSatisfy: #isFinished ]
			ifFalse: [ false ].
		allFinished ifTrue: [ self finishUp ] ].
	stats notifyUpdate.
]

{ #category : #private }
GtRlChecksRunner >> queueInImage: anAssociation timeout: taskTimeout [
	| task job |

	task := GtRrExplicitExampleTask exampleNames: { anAssociation }.
	task taskTimeout: taskTimeout.
	job := task asJob.
	job
		when: GtRrTaskCompletedAnnouncement
		send: #inImageTaskCompleted:
		to: self.
	job
		when: GtRrTaskFailedAnnouncement
		send: #inImageTaskCompleted:
		to: self.
	job
		when: GtRrJobCompletedAnnouncement
		send: #jobCompleted:
		to: self.
	self critical:
		[ jobs add: (inImageRunner submitJob: job) ].
]

{ #category : #accessing }
GtRlChecksRunner >> runInImageTasks [

	^ self completedTasks select: [ :task |
		task workerAttributes
			at: #runInImage
			ifAbsent: [ false ] ]
]

{ #category : #private }
GtRlChecksRunner >> runTaskFailures: aTaskFinishedAnnouncement [ 

	[ self critical:
		[ | task |
		"Ensure we have the task, and not its context"
		task := aTaskFinishedAnnouncement task task.
		task result do: [ :result | 
			(result isSuccess or: [ result isSkipped ]) ifFalse:
				[ | newTask job |
				newTask := task copy.
				job := newTask asJob.
				job taskTimeout: jobs first taskTimeout.
				jobs add: job.
				job
					when: GtRrTaskCompletedAnnouncement
					send: #uiProcessTaskCompleted:
					to: self.
				job
					when: GtRrTaskFailedAnnouncement
					send: #uiProcessTaskCompleted:
					to: self.
				job
					when: GtRrJobCompletedAnnouncement
					send: #jobCompleted:
					to: self.
				enqueueSubmitCount := enqueueSubmitCount + 1.
				Stdio stdout
					<< 'enqueueSubmit: ';
					<< enqueueSubmitCount asString;
					lf.
				BlTaskAction
					enqueueElement: (GtWorld allInstances detect: #isOpened)
					action: [
						enqueueRunCount := enqueueRunCount + 1.
						Stdio stdout
							<< 'runInImage starting: ';
							<< enqueueRunCount asString;
							lf.
						[ job runInImage ] ensure: 
							[ EpMonitor current enable ].
						Stdio stdout
							<< 'runInImage completed';
							lf.
						 ] ] ] ] ]
	forkNamed: self class name asString, ' runTaskFailures'.
]

{ #category : #private }
GtRlChecksRunner >> startInitialJob: aGtRrChecksJob [

	enqueueSubmitCount := 0.
	enqueueRunCount := 0.
	self critical:
		[ stats 
			state: #running;
			total: aGtRrChecksJob numberOfChecks.
		aGtRrChecksJob
			when: GtRrTaskCompletedAnnouncement
			send: #initialJobTaskCompleted:
			to: self.
		aGtRrChecksJob
			when: GtRrTaskFailedAnnouncement
			send: #initialJobTaskCompleted:
			to: self.
		aGtRrChecksJob
			when: GtRrJobCompletedAnnouncement
			send: #jobCompleted:
			to: self.
		jobs add: (workerRunner submitJob: aGtRrChecksJob).
		stats startTime: DateAndTime now. ].
]

{ #category : #private }
GtRlChecksRunner >> startRunners [
	workerRunner := GtRemoteRunner new.
	workerRunner
		startLogging;
		start.
	inImageRunner := GtRemoteRunner new.
	inImageRunner managerStartupAndShutdown
		poolSize: 0;
		startInImageWorker.
	times := GtRrCheckSchedulingTimes
			loadDefaultFromFile: FileLocator userData / 'Gt' / 'GtRrCheckSchedulingTimes.json'
			runner: workerRunner.
]

{ #category : #'as yet unclassified' }
GtRlChecksRunner >> stopRunners [

	workerRunner ifNotNil:
		[ workerRunner stop ].
	inImageRunner ifNotNil:
		[ inImageRunner stop ].
]

{ #category : #private }
GtRlChecksRunner >> storeCheckFailure: result [ 

	(result isSuccess or: [ result isSkipped ]) ifTrue: [ ^ self ].
	self critical:
		[ (checkFailures 
			at: result checkName 
			ifAbsentPut: [ OrderedCollection new ])
				add: result ].
]

{ #category : #private }
GtRlChecksRunner >> storeCheckResult: result [ 

	result isSkipped ifTrue:
		[ self critical:
			[ (checkSkips
				at: result checkName
				ifAbsentPut: [ OrderedCollection new ])
					add: result. ].
		^ self ].

	self critical:
		[ (checkResults 
			at: result checkName
			ifAbsentPut: [ OrderedCollection new ])
				add: result ].
]

{ #category : #private }
GtRlChecksRunner >> storeTaskResults: aTaskFinishedAnnouncement [ 

	self critical:
		[ | task |
		task := aTaskFinishedAnnouncement task.
		task result do: [ :result |
			self storeCheckResult: result.
			taskResults add: aTaskFinishedAnnouncement ] ].
]

{ #category : #private }
GtRlChecksRunner >> submitRetries: aTaskFinishedAnnouncement [ 

	self critical:
		[ | task |
		task := aTaskFinishedAnnouncement task.
		task result do: [ :result |
			(result isSuccess or: [ result isSkipped ]) ifFalse:
				[ self queueInImage: result checkName timeout: task taskTimeout ] ] ].
]

{ #category : #accessing }
GtRlChecksRunner >> successfulRunInImageResults [

	^ self successfulRunInImageTasks flatCollect: [ :task |
		task result select: #isSuccess ]
]

{ #category : #accessing }
GtRlChecksRunner >> successfulRunInImageTasks [

	^ self runInImageTasks select: [ :task |
		task hasResult and: [ task result anySatisfy: #isSuccess ] ]
]

{ #category : #accessing }
GtRlChecksRunner >> successfulWorkerInImageResults [

	^ self successfulWorkerInImageTasks flatCollect: [ :task |
		task result select: #isSuccess ]
]

{ #category : #accessing }
GtRlChecksRunner >> successfulWorkerInImageTasks [

	^ self workerInImageTasks select: [ :task |
		task hasResult and: [ task result anySatisfy: #isSuccess ] ]
]

{ #category : #private }
GtRlChecksRunner >> uiProcessTaskCompleted: aTaskFinishedAnnouncement [

	[ | task |
	task := aTaskFinishedAnnouncement task.
	task result do: [ :result |
		self storeCheckResult: result.
		self storeCheckFailure: result. ] ]
			forkNamed: self class name asString, ' runTaskFailures store results'.
	stats updateUiProcess: aTaskFinishedAnnouncement.
]

{ #category : #private }
GtRlChecksRunner >> updateCheckTimes [

	GtRrCheckSchedulingTimes default saveToFile: 
		FileLocator userData / 'Gt' / 'GtRrCheckSchedulingTimes.json'.
]

{ #category : #accessing }
GtRlChecksRunner >> workerInImageTasks [

	^ self completedTasks select: [ :task |
		task workerAttributes
			at: #workerInImage
			ifAbsent: [ false ] ]
]
