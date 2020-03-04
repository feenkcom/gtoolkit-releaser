Class {
	#name : #LogStorageAction,
	#superclass : #JenkinsURL,
	#instVars : [
		'_urlName',
		'__links',
		'_parent'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-OrgJenkinsciPluginsWorkflowSupportActions'
}

{ #category : #accessing }
LogStorageAction >> gtDisplayOn: stream [
	stream nextPutAll: _urlName
]

{ #category : #accessing }
LogStorageAction >> rawLog [
|data|
	data := znclient get: ('' join:{url. __links at:'self' at: 'href'}).
	^ data
]

{ #category : #accessing }
LogStorageAction >> urlName [
	^ _urlName
]
