Class {
	#name : #GithubOrganizationFolder,
	#superclass : #JenkinsURL,
	#instVars : [
		'_actions',
		'_numberOfFolders',
		'_scmSource',
		'_name',
		'_icon',
		'_pipelineFolderNames',
		'_permissions',
		'_fullName',
		'_repos',
		'_organization',
		'__links',
		'_numberOfPipelines',
		'_fullDisplayName',
		'_latestRun',
		'_scanAllRepos',
		'_parameters',
		'_displayName',
		'_disabled'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-IoJenkinsBlueoceanBlueocean_github_pipeline'
}

{ #category : #accessing }
GithubOrganizationFolder >> gtItemsFor: aView [
	<gtView>
	| aList |

	aList := aView columnedList
		title: 'Pipelines' translated;
		priority: 50;
		items: [ self pipelines].

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
GithubOrganizationFolder >> pipelines [
	|rawPipelines codeGenerator| 
	rawPipelines := self rawPipelines.
	codeGenerator := JSONCodeGenerator new.
	^ rawPipelines collect:[:rawPipe |
		|model|
		model := codeGenerator modelFrom: rawPipe.
		model url: url.
		model znclient: znclient.
		model json: rawPipe.
		model]
	
]

{ #category : #accessing }
GithubOrganizationFolder >> rawPipelines [
	|data|
	data := znclient get: ('' join:{url. __links at:'pipelines' at: 'href'}).
	^ (NeoJSONReader fromString: data)
]
