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
GithubOrganizationFolder >> gtDisplayOn: stream [
	stream nextPutAll: _fullDisplayName
]

{ #category : #accessing }
GithubOrganizationFolder >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Pipelines' translated;
		priority: 10;
		items: [ self pipelines];
		column: 'Index' translated item: [ :each :eachIndex | eachIndex asRopedText foreground: Color gray] width: 30;
		column: 'Item' translated format: [ :each | each gtDisplayText ]
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
