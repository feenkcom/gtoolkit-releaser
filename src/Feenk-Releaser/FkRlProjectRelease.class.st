Class {
	#name : #FkRlProjectRelease,
	#superclass : #FkRlRelease,
	#instVars : [
		'project'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #ui }
FkRlProjectRelease >> gtGeneratedSourceFor: aView [
	<gtView> 
	^ aView textEditor
		title: 'Release source';
		text: [ self project generateSourceWithSemanticVersion: self semanticVersion versionString];
		priority: 15
]

{ #category : #printing }
FkRlProjectRelease >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self project name.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self semanticVersion versionString.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
FkRlProjectRelease >> project [
	^ project
]

{ #category : #accessing }
FkRlProjectRelease >> project: aProject [
	project := aProject
]
