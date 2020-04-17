"
I am an abstraction for a type of dependency in the loading configuration of a system.
"
Class {
	#name : #GtRlNode,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #testing }
GtRlNode >> isPackageModel [
	^ false
]

{ #category : #testing }
GtRlNode >> isProjectModel [
	^ false
]

{ #category : #accessing }
GtRlNode >> name [
	^ name
]

{ #category : #accessing }
GtRlNode >> name: aString [
	self assert: [ aString notNil ].
	name := aString
]

{ #category : #printing }
GtRlNode >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]
