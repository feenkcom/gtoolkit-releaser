Class {
	#name : #GTImageVersion,
	#superclass : #Object,
	#classInstVars : [
		'version',
		'timestamp'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GTImageVersion class >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GTImageVersion class >> timestamp: aTimestamp [
	timestamp := aTimestamp
]

{ #category : #accessing }
GTImageVersion class >> version [
	^ version
]

{ #category : #accessing }
GTImageVersion class >> version: aVersion [
	version := aVersion
]
