Class {
	#name : #BranchImpl,
	#superclass : #JenkinsURL,
	#instVars : [
		'_fullDisplayName',
		'_parameters',
		'_actions',
		'_estimatedDurationInMillis',
		'_name',
		'_disabled',
		'_permissions',
		'_organization',
		'_branch',
		'_latestRun',
		'_fullName',
		'__links',
		'_weatherScore',
		'_displayName'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanRestImplPipeline'
}

{ #category : #accessing }
BranchImpl >> gtDisplayOn: stream [
	stream nextPutAll: _fullName
]

{ #category : #accessing }
BranchImpl >> gtRunsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Runs' translated;
		priority: 50;
		items: [ self runs];
		column: 'Status' translated do: [ :column | 
			column
				itemStencil: [ :each | BlElement new geometry: BlCircle new; background: each resultBackgroundColor; size: 10@10; margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
				noResize ];
		column: 'Item' translated format: [ :each | each gtDisplayText ] width: 50;
		column: 'Result' translated format: [ :each | each result ];
		column: 'Duration' translated format: [ :each | (each duration roundTo: 1 second) humanReadablePrintString ];
		column: 'Start time' translated format: [ :each | String streamContents: [:s | each startTime printSeparateDateAndTimeOn: s]]
]

{ #category : #accessing }
BranchImpl >> rawRuns [
		|data|
	data := znclient get: ('' join:{url. __links at:'runs' at: 'href'}).
	^ (NeoJSONReader fromString: data)
	
]

{ #category : #accessing }
BranchImpl >> runs [
	|raws codeGenerator| 
	raws := self rawRuns.
	codeGenerator := JSONCodeGenerator new.
	^ raws collect:[:raw |
		|model|
		model := codeGenerator modelFrom: raw.
		model url: url.
		model znclient: znclient.
		model json: raw.
		model]
]
