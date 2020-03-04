Class {
	#name : #JenkinsURL,
	#superclass : #Object,
	#instVars : [
		'url',
		'znclient',
		'rawData'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JenkinsURL >> json [
	^ rawData
]

{ #category : #accessing }
JenkinsURL >> json: aDictionary [
	rawData := aDictionary
]

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
