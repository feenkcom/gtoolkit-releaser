Class {
	#name : #JenkinsJob,
	#superclass : #Object,
	#instVars : [
		'name',
		'client',
		'url'
	],
	#category : #'GToolkit-Releaser-Jenkins'
}

{ #category : #'as yet unclassified' }
JenkinsJob class >> name: jobName client: aZnClient url: theUrl [
	^ (JenkinsJob new) name: jobName; client:aZnClient; url: theUrl
]

{ #category : #accessing }
JenkinsJob >> client [
	^ client
]

{ #category : #accessing }
JenkinsJob >> client: anObject [
	client := anObject
]

{ #category : #accessing }
JenkinsJob >> gtLastBuildLogFor: aView [
	<gtView>
	^ aView textEditor 
		title: 'Last Build Log';
		text: self lastBuildLog 
]

{ #category : #accessing }
JenkinsJob >> lastBuildLog [
	^ client get: ('' join: 
	{ url . 
	  '/job/' . 
	  name . 
	  '/lastBuild/consoleText'})
]

{ #category : #accessing }
JenkinsJob >> name [
	^ name
]

{ #category : #accessing }
JenkinsJob >> name: anObject [
	name := anObject
]

{ #category : #accessing }
JenkinsJob >> url [
	^ url
]

{ #category : #accessing }
JenkinsJob >> url: anObject [
	url := anObject
]
