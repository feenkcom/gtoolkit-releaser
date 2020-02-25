Class {
	#name : #WfJobRunNode,
	#superclass : #JenkinsWFAPI,
	#instVars : [
		'durationMillis',
		'pauseDurationMillis',
		'status',
		'startTimeMillis',
		'execNode',
		'name',
		'id',
		'_self',
		'parentIds',
		'parentNode',
		'parentNodes',
		'parameterDescription',
		'stageFlowNodes'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-Wfapi'
}

{ #category : #accessing }
WfJobRunNode >> parentJSON [
	^ NeoJSONReader fromString: (znclient get: self parentURL)
]

{ #category : #accessing }
WfJobRunNode >> parentNode [
	|json theObject codeGenerator|
	theObject := nil.
	parentIds isNotNil ifTrue: [
		json := self parentJSON.
		codeGenerator := JSONCodeGenerator new.
		theObject := codeGenerator 
						modelFrom:json className:'WfJobRunNode'
						znclient: self znclient.
		codeGenerator ensureInstVarNamed: 'parentNode' inClass: self class.
		codeGenerator setWfAttribute: 'parentNode' toValue: theObject inObject: self.
		theObject parentNode].
	^ theObject
	
]

{ #category : #accessing }
WfJobRunNode >> parentURL [
	|p selfLink re|
	p := parentIds at:1.
	re := ('node/',id) asRegex.
	selfLink:=self links at:#self at:#href.
	^ re copy: selfLink replacingMatchesWith: ('node/',p)
]
