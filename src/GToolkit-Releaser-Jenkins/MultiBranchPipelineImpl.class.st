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
	| aList |

	aList := aView columnedList
		title: 'Branches' translated;
		priority: 50;
		items: [ self branches].

	aList column
		title: 'Index' translated;
		width: 30;
		item: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray].
	
	aList column
		title: 'Item' translated;
		item: [ :eachItem :eachIndex | eachItem ];
		itemFormat: [ :eachItem | eachItem gtDisplayText ].
	
	^ aList
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
