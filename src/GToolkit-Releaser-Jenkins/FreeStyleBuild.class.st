Class {
	#name : #FreeStyleBuild,
	#superclass : #JenkinsURL,
	#instVars : [
		'_url',
		'_number',
		'_parent',
		'_actions',
		'_result',
		'_changeSet',
		'_duration',
		'_building',
		'_keepLog',
		'__class',
		'_artifacts',
		'_executor',
		'_timestamp',
		'_estimatedDuration',
		'_fullDisplayName',
		'_description',
		'_builtOn',
		'_displayName',
		'_id',
		'_queueId',
		'_culprits'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-HudsonModel'
}

{ #category : #accessing }
FreeStyleBuild >> buildLog [
	^ self znclient get: ('' join: { self url . '/consoleText'})
]

{ #category : #accessing }
FreeStyleBuild >> gtBuildLogFor: aView [
	<gtView>
	^ aView textEditor 
		title: 'Build Log';
		text: self buildLog 
]

{ #category : #accessing }
FreeStyleBuild >> number [ 
	^ _number
]

{ #category : #accessing }
FreeStyleBuild >> parent: theParent [
	_parent := theParent 
]

{ #category : #accessing }
FreeStyleBuild >> url [ 
	^ _url
]

{ #category : #accessing }
FreeStyleBuild >> znclient [ 
	^ _parent znclient 
]
