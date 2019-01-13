Class {
	#name : #JenkinsURL,
	#superclass : #Object,
	#instVars : [
		'url',
		'znclient'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JenkinsURL >> url [
	^ url
]

{ #category : #accessing }
JenkinsURL >> url: anURL [
	url := anURL
]

{ #category : #accessing }
JenkinsURL >> znclient [
	^ znclient
	
]

{ #category : #accessing }
JenkinsURL >> znclient: aZNClient [
	znclient := aZNClient 
	
]
