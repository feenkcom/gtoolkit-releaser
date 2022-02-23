Class {
	#name : #GtRlPackageLoadAction,
	#superclass : #GtRlProjectLoadDirectiveAction,
	#instVars : [
		'package'
	],
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : #accessing }
GtRlPackageLoadAction >> descriptionDetails [
	^ self package name
]

{ #category : #accessing }
GtRlPackageLoadAction >> name [
	^ 'Load package'
]

{ #category : #accessing }
GtRlPackageLoadAction >> package [
	^ package
]

{ #category : #accessing }
GtRlPackageLoadAction >> package: aPackage [
	self assert: [ aPackage notNil ].
	package := aPackage
]

{ #category : #actions }
GtRlPackageLoadAction >> performAction [ 
	self assert: [ self package notNil ].
	
	self package icebergPackage load
]

{ #category : #printing }
GtRlPackageLoadAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self package name;
		nextPutAll: ',';
		nextPutAll: self loadDirective projectName;
		nextPutAll: ')'
		
]
