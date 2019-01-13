Class {
	#name : #FreeStyleProject,
	#superclass : #JenkinsURL,
	#instVars : [
		'name',
		'_parent'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generated-HudsonModel'
}

{ #category : #accessing }
FreeStyleProject >> get [
	| codeGenerator json|
	codeGenerator := JSONCodeGenerator new.
	json := self znclient get: ('' join: { _parent url . '/' . url . '/' . name . '/api/json?pretty=true'}).
	codeGenerator updateObject: self with: (NeoJSONReader fromString: json).

]

{ #category : #accessing }
FreeStyleProject >> name [
	^ name
]

{ #category : #accessing }
FreeStyleProject >> znclient [ 
	^ _parent znclient 
]
