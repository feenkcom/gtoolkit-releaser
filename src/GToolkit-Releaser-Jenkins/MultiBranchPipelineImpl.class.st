Class {
	#name : #MultiBranchPipelineImpl,
	#superclass : #JenkinsURL,
	#instVars : [
		'_actions',
		'_weatherScore',
		'_numberOfFolders',
		'_scmSource',
		'_name',
		'_pipelineFolderNames',
		'_permissions',
		'_fullName',
		'_numberOfSuccessfulPullRequests',
		'_totalNumberOfPullRequests',
		'_numberOfFailingBranches',
		'_estimatedDurationInMillis',
		'_numberOfFailingPullRequests',
		'_organization',
		'__links',
		'_totalNumberOfBranches',
		'_numberOfPipelines',
		'_fullDisplayName',
		'_numberOfSuccessfulBranches',
		'_parameters',
		'_displayName',
		'_branchNames',
		'_disabled'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
MultiBranchPipelineImpl >> branches [
	|rawBranches codeGenerator| 
	rawBranches := self rawBranches.
	codeGenerator := JSONCodeGenerator new.
	^ rawBranches collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]

{ #category : #accessing }
MultiBranchPipelineImpl >> gtBranchesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Branches' translated;
		priority: 50;
		items: [ self branches];
		column: 'Status' translated do: [ :column | 
			column
				itemStencil: [ :each | BlElement new geometry: BlCircle new; background: each lastFinishedRun resultBackgroundColor; size: 10@10; margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
				noResize ];
		column: 'Branch' translated format: [ :each | each gtDisplayText ] width: 200;
		column: 'Last duration' translated format: [ :each | (each lastFinishedRun duration roundTo: 1 second) humanReadablePrintString ] width: 200;
		column: 'Last run start time' translated format: [ :each | String streamContents: [:s | each lastFinishedRun startTime printSeparateDateAndTimeOn: s]]
]

{ #category : #accessing }
MultiBranchPipelineImpl >> gtDisplayOn: stream [
	stream nextPutAll: _name
]

{ #category : #accessing }
MultiBranchPipelineImpl >> rawBranches [
		|data|
	data := znclient get: ('' join:{url. __links at:'branches' at: 'href'}).
	^ (NeoJSONReader fromString: data)
	
]
