Class {
	#name : #FkRlBranch,
	#superclass : #Object,
	#instVars : [
		'repository',
		'icebergBranch'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
FkRlBranch class >> for: anIceBranch [
	^ self new 
		icebergBranch: anIceBranch
]

{ #category : #accessing }
FkRlBranch >> icebergBranch [
	^ icebergBranch
]

{ #category : #accessing }
FkRlBranch >> icebergBranch: anIceBranch [
	icebergBranch := anIceBranch
]

{ #category : #printing }
FkRlBranch >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self summaryDescription;
		nextPutAll: ')'
]

{ #category : #accessing }
FkRlBranch >> repository [
	^ repository
]

{ #category : #accessing }
FkRlBranch >> repository: aRepository [
	repository := aRepository
]

{ #category : #printing }
FkRlBranch >> summaryDescription [
	^ String streamContents: [ :aStream |
		aStream
			nextPutAll: self icebergBranch name;
			nextPutAll: ', ';
			nextPutAll: (self icebergBranch isLocal ifTrue: [ 'local' ] ifFalse: [ 'remote' ] ) ]
]
