Class {
	#name : #FreeStyleProject,
	#superclass : #JenkinsURL,
	#instVars : [
		'_name',
		'_parent',
		'_actions',
		'_property',
		'_lastSuccessfulBuild',
		'_buildable',
		'_color',
		'_lastBuild',
		'__class',
		'_scm',
		'_builds',
		'_fullName',
		'_downstreamProjects',
		'_upstreamProjects',
		'_displayNameOrNull',
		'_queueItem',
		'_keepDependencies',
		'_concurrentBuild',
		'_fullDisplayName',
		'_lastUnsuccessfulBuild',
		'_description',
		'_healthReport',
		'_lastUnstableBuild',
		'_labelExpression',
		'_lastCompletedBuild',
		'_displayName',
		'_url',
		'_nextBuildNumber',
		'_firstBuild',
		'_inQueue',
		'_lastFailedBuild',
		'_lastStableBuild'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-HudsonModel'
}

{ #category : #accessing }
FreeStyleProject >> builds [ 
	_builds ifNil: [ self get ].
	^ _builds
]

{ #category : #accessing }
FreeStyleProject >> get [
	| codeGenerator json|
	codeGenerator := JSONCodeGenerator new.
	json := self znclient get: ('' join: { _parent url . '/' . url . '/' . _name . '/api/json?pretty=true'}).
	codeGenerator updateObject: self with: (NeoJSONReader fromString: json).

]

{ #category : #accessing }
FreeStyleProject >> gtBuildsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Builds' translated;
		priority: 10;
		items: [ self builds ];
		column: 'ID' translated do: [ :aColumn | 
			aColumn 
				item: [ :build | build number ]; 
				width: 30 ];
		column: 'Result' translated do: [ :aColumn | 
			aColumn 
				item: [ :build | |result| result := ''.
					 build result ifNotNil: [ result := build result ].
					result ]; 
				width: 80 ];
		column: 'URL' translated do: [ :aColumn | 
			aColumn 
				item: [ :build | build url ]; 
				matchParent ]
]

{ #category : #accessing }
FreeStyleProject >> name [
	^ _name
]

{ #category : #accessing }
FreeStyleProject >> znclient [ 
	^ _parent znclient 
]
