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
		'stats',
		'initialisationProcess'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlChecksRunner class >> checksFactory: aGtRrChecksFactory [
	"Run the examples in the supplied factory"

	^ self new checksFactory: aGtRrChecksFactory
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

	"allPackageNames := allPackageNames first: 100."

	examples := allPackageNames flatCollect: [ :pName | 
		(self class packageOrganizer packageNamed: pName) gtExamplesAllContained ].

	factory := GtRrChecksFactory new.
	factory addExampleTestNames: 
		(examples collect: [ :each | each providerClass name asSymbol -> each selector asSymbol ]).
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
	)
]

{ #category : #accessing }
GtRlChecksRunner class >> knownErrors [

	^ {
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithBranchStrategyOnOneVersionRepo.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithDedicatedBranchForSecondVersion.
	#GtRlLeafRepositoryReleaseExamples -> #basicReleaseStructureWithExistingTag.
	#GtRlLeafRepositoryReleaseExamples -> #projectStructureWithThreeDependencies.
	#GtRlLeafRepositoryReleaseExamples -> #projectWithOneReleasedVersionAndChanges.
	#GtRlLeafRepositoryReleaseExamples -> #projectBWithNoVersion.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithLoadedTagStrategyOnSingleRepoUsingConfig.
	#GtRlLeafRepositoryReleaseExamples -> #projectWithOneReleasedVersionAndNewCommit.
	#GtRlLeafRepositoryReleaseExamples -> #projectAWithNoVersion.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithBranchStrategyOnNoVersionRepo.
	#LeSnippetStateExtractorExamples -> #extractCommonStateForAllSnippetTypes.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithDedicatedBranchForInitialVersion.
	#GtRlLeafRepositoryReleaseExamples -> #printBaselineCodeReleaseForFourRepositoriesWithNewCommit.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithBranchStrategyForcingReleaseOnOneVersionRepo.
	#GtRlLeafRepositoryReleaseExamples -> #projectStructureWithOneChildDependency.
	#GtRlLeafRepositoryReleaseExamples -> #projectWithOneReleasedVersionAndNoChanges.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithLoadedTagStrategyOnSingleRepo.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithLatestCommitForInitialVersion.
	#GtRlLeafRepositoryReleaseExamples -> #basicReleaseStructureWithNoVersions.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithLoadedTagForSingleRepoUsingConfig.
	#GtRlLeafRepositoryReleaseExamples -> #basicReleaseWithBranchStrategyOnNoVersionsRepo.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithBranchStrategyOnOneVersionRepoWithNewCommit.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithLoadedTagForSingleRepo.
	#GtRlLeafRepositoryReleaseExamples -> #basicReleaseWithLatestCommitStrategyOnNoVersionRepo.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWithLatestCommitStrategyOnNoVersionRepo.
	#GtRlLeafRepositoryReleaseExamples -> #projectWithTagAndNoVersion.
	#LeSnippetStateExtractorExamples -> #extractCommonStateForAllEmptySnippetTypes.
	#LeSnippetStateExtractorExamples -> #extractSpecificStateForAllEmptySnippetTypes.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectWithOneReleasedVersionAndChanges.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWithHeadCommitChildRepositoryWithNoChange.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectWithOneReleasedVersionAndNoChanges.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWithHeadCommitChildRepository.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectWithTagAndNoVersion.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectAWithNoVersion.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectWithOneReleasedVersionAndNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWorkflowForHeadCommitChild.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectBWithNoVersion.
	#GtRlDedicatedBranchRootReleaseExamples -> #printMetacelloBaselineCodeReleaseForFourRepositoriesWithNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWorkflowForMultipleRepositoriesWithNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #printBaselineCodereleaseForFourRepositoriesWithNoVersionAndNoNewChanges.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectStructureWithThreeDependencies.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseForFourRepositoriesWithNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWorkflowForInitialVersionInMultipleRepositories.
	#GtRlDedicatedBranchRootReleaseExamples -> #projectStructureWithOneChildDependency.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseForFourRepositoriesWithNoVersionAndNoNewChanges.
	#GtRlDedicatedBranchRootReleaseExamples -> #printBaselineCodeReleaseForFourRepositoriesWithNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #printBaselineCodeReleaseWithHeadCommitChildRepository.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWithHeadCommitChildRepositoryWithNewCommit.
	#GtRlDedicatedBranchRootReleaseExamples -> #releaseWorkflowForHeadCommitChildWithNewCommit.
	#GtGitElementExamples -> #scripterOnExpandedElementWithDeletedRepository.
	#GtGitElementExamples -> #scripterOnExpandedElementWithInitializationDone.
	#GtGitElementExamples -> #scripterOnExpandedElementWithExpandedProperties.
	#GtGitElementExamples -> #scripterOnExpandedElementWithEditedBranch.
	#GtRlReleaserExamples -> #projectBWithNoVersion.
	#GtRlReleaserExamples -> #projectWithOneReleasedVersionAndNewCommit.
	#GtRlReleaserExamples -> #projectAWithNoVersion.
	#GtRlReleaserExamples -> #projectWithTagAndNoVersion.
	#GtRlReleaserExamples -> #projectStructureWithOneChildDependency.
	#GtRlReleaserExamples -> #projectWithOneReleasedVersionAndChanges.
	#GtRlReleaserExamples -> #projectStructureWithThreeDependencies.
	#GtRlReleaserExamples -> #projectWithOneReleasedVersionAndNoChanges.
	#GtRlLeafRepositoryReleaseExamples -> #releaseWorkflowWithDedicatedBranchForSecondForcedVersion.
	#GtRlLeafRepositoryReleaseExamples -> #basicReleaseWithLoadedTagStrategyOnSingleRepo.
	}
]

{ #category : #accessing }
GtRlChecksRunner class >> knownFailures [

	^ {
	#GtInspectorScripterExamples -> #stackMachineV1WithCodeEvaluated.
	#GtWardleyMapDecoratorWithScripterExamples -> #mapWithLepiterPageAction_ClickOnMapCanvasDecorator.
	#LeDatabaseByScripterExamples -> #scripterWithLinkClicked.
	#GtWorldByScripterExamples -> #executeInspectorPlaygroundSnippetInTheThirdPage.
	#GtWorldByScripterExamples -> #worldSpotter_ResizeVertically.
	#GtWorldByScripterExamples -> #executePlaygroundSnippet.
	#GtWorldByScripterExamples -> #clickBackOnPlaygroundInTheFirstPane.
	#GtWorldByScripterExamples -> #displayClassHierarchyDropdownInSecondPane_SelectAnotherClass.
	#GtWorldByScripterExamples -> #browsePackageInSecondPane.
	#GtWorldByScripterExamples -> #displayClassHierarchyDropdownInSecondPane.
	#GtWorldByScripterExamples -> #worldSpotter_ResizeVertically_ClosePressingEscape.
	#GtWorldByScripterExamples -> #worldSpotter_ResizeVertically_ClosePressingEscape_ResizeSecondTime.
	#GtWorldByScripterExamples -> #displayRustObjectDefiningMethodContextMenu.
	#GtWorldByScripterExamples -> #clickOnInspectorInTheSecondPane.
	#GtWorldByScripterExamples -> #typeSnippetInPlayground.
	#GtWorldByScripterExamples -> #clickOnPackageEditableNameInSecondPane.
	#GtWorldByScripterExamples -> #displayClassHierarchyDropdownInSecondPane_SelectAnotherClass_closePinnedMenu.
	#GtWorldByScripterExamples -> #displayRustObjectDefiningMethodContextMenu_hoverDefiningMethod.
	#GtWorldByScripterExamples -> #createInstanceTwiceDisplayingTheSecondTab.
	#GtWorldByScripterExamples -> #cannotClickOnCoderIssue.
	#GtWorldByScripterExamples -> #clickAgainOnPackageEditableNameInTheFirstPane.
	#GtWorldByScripterExamples -> #selectClassInSecondPane.
	#GtWorldByScripterExamples -> #displayRustObjectDefiningMethodContextMenu_inspectDefiningMethod.
	#GtWorldByScripterExamples -> #inspectRustRemoteObject.
	}
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> preCommitExamples [
	"Run the dedicated release branch examples, 
	minus checks that are known to fail in this environment,
	but should still pass in the CI."

	^ self checksFactory: self preCommitExamplesFactory.
]

{ #category : #'instance creation' }
GtRlChecksRunner class >> preCommitExamplesFactory [
	| factory tasks task checkNames |

	factory := self dedicatedReleaseBranchExamplesFactory.
	tasks := factory tasks.
	self assert: tasks size equals: 1.
	task := tasks first.
	checkNames := task checkNames asOrderedCollection.
	checkNames
		removeAll: self knownFailures;
		removeAll: self knownErrors.
	task checkNames: checkNames asArray.
	^ factory.
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
		(self class packageOrganizer packageNamed: pName) gtExamplesAllContained ].

	factory := GtRrChecksFactory new.
	factory addExampleTestNames: 
		(examples collect: [ :each | each providerClass name -> each selector ]).
	^ factory
]

{ #category : #initialization }
GtRlChecksRunner >> checksFactory: aGtRrChecksFactory [
	"Run the examples in the supplied factory"
	| initialJob |

	initialisationProcess := 
		[ "Start the runner first so the default GtRrCheckSchedulingTimes is available"
		self startRunners.
		"Generate and submit the job"
		aGtRrChecksFactory groupTasksByTime.
		initialJob := aGtRrChecksFactory job.
		initialJob taskTimeout: 5 minutes.
		self initialJob: initialJob ] fork.
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
GtRlChecksRunner >> errorNames [
	"Answer a collection of check names that errored in the last run"

	^ self errorResults collect: [ :each |
		each checkName ]
]

{ #category : #accessing }
GtRlChecksRunner >> errorResults [

	^ self critical:
		[ (checkFailures collect: #last as: Array)
			select: [ :each | each isError ] ].
]

{ #category : #accessing }
GtRlChecksRunner >> failureNames [
	"Answer a collection of check names that failed in the last run"

	^ self failureResults collect: [ :each |
		each checkName ]
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
	self updateSchedulingTimes.
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
		items: [ self successfulUiResults ];
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
	stats := GtRlChecksRunnerStats new
		rlRunner: self.
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
GtRlChecksRunner >> loadSchedulingTimes [
	"Load the times used to sequence the checks"
	| timesFile |

	timesFile := self schedulingTimesFile.
	times := timesFile exists ifTrue:
		[ GtRrCheckSchedulingTimes
			loadDefaultFromFile: timesFile
			runner: workerRunner ]
	ifFalse:
		[ GtRrCheckSchedulingTimes new
			remoteRunner: workerRunner ]
]

{ #category : #private }
GtRlChecksRunner >> queueInImage: anAssociation timeout: taskTimeout [
	| task job |

	task := GtRrExplicitExampleTask exampleNames: { anAssociation }.
	task taskTimeout: taskTimeout.
	job := task asJob.
	job name: 'In-image job'.
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
			ifNil: [ false ]
			ifNotNil: [ :attrs |
				attrs
					at: #runInImage
					ifAbsent: [ false ] ] ]
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
				job 
					taskTimeout: jobs first taskTimeout;
					name: 'UI job'.
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
GtRlChecksRunner >> schedulingTimesFile [
	"Answer the file used to store scheduling (check) times"
	| timesOrigin timesDir |

	"Different platforms support a different subset of the known origins.
	Find one that is available, and will be the same across images (on that platform)."
	timesOrigin := #(userData preferences imageDirectory) detect:[ :origin |
		(FileLocator supportedOrigins includes: origin) and:
		[ (FileLocator origin: origin) isDirectory ] ].
	timesDir := (FileLocator origin: timesOrigin) / 'Gt'.
	timesDir ensureCreateDirectory.
	^ timesDir / 'GtRrCheckSchedulingTimes.json'.
]

{ #category : #private }
GtRlChecksRunner >> startInitialJob: aGtRrChecksJob [

	enqueueSubmitCount := 0.
	enqueueRunCount := 0.
	aGtRrChecksJob name: 'Initial Job'.
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
	"Start the headless and in-image runners and workers"

	"Headless workers sync changes, but not ongoing code sync"
	workerRunner := GtRemoteRunner new.
	workerRunner
		managerStartupAndShutdown: GtRrLocalManagerStartupAndShutdown new;
		startLogging.
	workerRunner managerStartupAndShutdown workerManager
		addVmArguments: #('--print-stack-on-signals').
	workerRunner
		start.

	inImageRunner := GtRemoteRunner new.
	inImageRunner managerStartupAndShutdown
		poolSize: 0;
		startInImageWorker.

	self loadSchedulingTimes
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
		taskResults add: aTaskFinishedAnnouncement.
		task result do: [ :result | self storeCheckResult: result ] ].
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
GtRlChecksRunner >> successfulUiResults [

	^ self successfulUiTasks flatCollect: [ :task |
		task result select: #isSuccess ]
]

{ #category : #accessing }
GtRlChecksRunner >> successfulUiTasks [

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
GtRlChecksRunner >> updateSchedulingTimes [

	GtRrCheckSchedulingTimes default saveToFile: 
		self schedulingTimesFile
]

{ #category : #accessing }
GtRlChecksRunner >> workerInImageTasks [

	^ self completedTasks select: [ :task |
		task workerAttributes 
			ifNil: [ false ]
			ifNotNil: [ :attrs |
				attrs
					at: #workerInImage
					ifAbsent: [ false ] ] ]
]
