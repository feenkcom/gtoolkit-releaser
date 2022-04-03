Class {
	#name : #GtRlLoaderActionExecutedEvent,
	#superclass : #Object,
	#instVars : [
		'startedSignal',
		'completedSignal'
	],
	#category : #'GToolkit-Releaser-Loader-Logging'
}

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> actionDescription [
	^ self startedSignal actionDescription
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> actionType [
	^ self startedSignal actionType
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> baselineName [
	^ self startedSignal baselineName
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> completedSignal [

	^ completedSignal
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> completedSignal: anObject [

	completedSignal := anObject
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> duration [
	^ self completedSignal timestamp - self startedSignal
	 timestamp 
]

{ #category : #printing }
GtRlLoaderActionExecutedEvent >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(';
		<< self baselineName;
		<< ', ';
		<< self actionType;
		<< ', ';
		<< self actionDescription;
		<< ', ';
		<< self duration asString;
		<< ')'
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> startedSignal [

	^ startedSignal
]

{ #category : #accessing }
GtRlLoaderActionExecutedEvent >> startedSignal: anObject [

	startedSignal := anObject
]
