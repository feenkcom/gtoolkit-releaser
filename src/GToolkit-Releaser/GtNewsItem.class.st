Class {
	#name : #GtNewsItem,
	#superclass : #Object,
	#instVars : [
		'version',
		'newItem'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtNewsItem >> newItem [ 
	^ newItem
]

{ #category : #accessing }
GtNewsItem >> newItem: aNewItem [
	newItem := aNewItem
]

{ #category : #accessing }
GtNewsItem >> version [
	^ version
]

{ #category : #accessing }
GtNewsItem >> version: aVersion [
	version := aVersion
]
