Class {
	#name : #GtRlProjectReference,
	#superclass : #GtRlNode,
	#instVars : [
		'referencedProject'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #testing }
GtRlProjectReference >> isProjectReference [
	^ true
]

{ #category : #accessing }
GtRlProjectReference >> referencedProject [
	^ referencedProject
]

{ #category : #accessing }
GtRlProjectReference >> referencedProject: aProject [
	referencedProject := aProject
]
