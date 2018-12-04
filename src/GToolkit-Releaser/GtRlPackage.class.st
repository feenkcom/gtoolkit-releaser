Class {
	#name : #GtRlPackage,
	#superclass : #GtRlNode,
	#instVars : [
		'name',
		'dependencies',
		'parentProject'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlPackage >> dependencies [
	^ dependencies
]

{ #category : #accessing }
GtRlPackage >> dependencies: aSymbolArray [
	dependencies := aSymbolArray
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
