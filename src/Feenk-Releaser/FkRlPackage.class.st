Class {
	#name : #FkRlPackage,
	#superclass : #FkRlNode,
	#instVars : [
		'name',
		'dependencies',
		'parentProject'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlPackage >> dependencies [
	^ dependencies
]

{ #category : #accessing }
FkRlPackage >> dependencies: aSymbolArray [
	dependencies := aSymbolArray
]

{ #category : #accessing }
FkRlPackage >> name [
	^ name
]

{ #category : #accessing }
FkRlPackage >> name: aString [
	name := aString
]

{ #category : #accessing }
FkRlPackage >> parentProject [
	^ parentProject
]

{ #category : #accessing }
FkRlPackage >> parentProject: aProject [
	parentProject := aProject
]
