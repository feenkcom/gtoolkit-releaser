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
	stream nextPutAll: _name
]

{ #category : #accessing }
BranchImpl >> gtRunsFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: 'Runs' translated;
		priority: 50;
		items: [ self runs].

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
