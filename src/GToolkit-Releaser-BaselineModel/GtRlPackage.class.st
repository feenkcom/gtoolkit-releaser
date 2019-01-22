"
I model a package that is loaded by a project.

I have as main attributes:
	- the name of the package 
	- the project that contains me
	- dependencies to other packages or projects
	
I do not have an explicit repository. I am placed in the same repository as the project that contains me.
"
Class {
	#name : #GtRlPackage,
	#superclass : #GtRlNode,
	#instVars : [
		'name',
		'dependencies',
		'parentProject'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #converting }
GtRlPackage >> asRPackage [
	^ self name asPackage
]

{ #category : #accessing }
GtRlPackage >> dependencies [
	^ dependencies
]

{ #category : #accessing }
GtRlPackage >> dependencies: aSymbolArray [
	dependencies := aSymbolArray
]

{ #category : #initialization }
GtRlPackage >> initialize [ 	
	super initialize.
	dependencies := OrderedCollection new
]

{ #category : #accessing }
GtRlPackage >> name [
	^ name
]

{ #category : #accessing }
GtRlPackage >> name: aString [
	name := aString
]

{ #category : #accessing }
GtRlPackage >> parentProject [
	^ parentProject
]

{ #category : #accessing }
GtRlPackage >> parentProject: aProject [
	parentProject := aProject
]

{ #category : #printing }
GtRlPackage >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]
