"
I model a dependency to another project from a project.

I directly hold the referenced project, so it should be resolved before.
"
Class {
	#name : #GtRlProjectReference,
	#superclass : #GtRlNode,
	#instVars : [
		'referencedProject'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlProjectReference class >> forReferencedProject: aProject [
	^ self new
		referencedProject: aProject
]

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
	self assert: [ aProject notNil ].
	self 
		assert: [ referencedProject isNil ]
		description: 'The referenced project of a node is immutable'.  
		
	referencedProject := aProject.
	self name: aProject name.
]
