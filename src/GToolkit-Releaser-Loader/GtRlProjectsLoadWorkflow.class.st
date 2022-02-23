Class {
	#name : #GtRlProjectsLoadWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootLoadDirective',
		'loadActions',
		'visitedLoadDirectives'
	],
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : #actions }
GtRlProjectsLoadWorkflow >> executeLoadActions [
	self loadActions do: [ :aLoadAction |
		aLoadAction execute ]
]

{ #category : #formatting }
GtRlProjectsLoadWorkflow >> format: aString for: anAction [
	^ anAction isExecuted
		ifTrue: [ aString asRopedText foreground: Color gray ] 
		ifFalse: [ aString ]
]

{ #category : #'gt-extensions' }
GtRlProjectsLoadWorkflow >> gtLoadActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Load actions' translated;
		priority: 50;
		items: [ self loadActions ifNil: [ #() ] ];
		column: 'Action' text: [ :anAction | 
			self format: anAction name for: anAction ];
		column: 'Details' text: [ :anAction | 
			self format: anAction descriptionDetails for: anAction ];
		column: 'Project' text: [ :anAction | 
			self 
				format: anAction loadDirective projectName
				for: anAction ]
]

{ #category : #accessing }
GtRlProjectsLoadWorkflow >> loadActions [
	^ loadActions
]

{ #category : #accessing }
GtRlProjectsLoadWorkflow >> rootLoadDirective [
	^ rootLoadDirective
]

{ #category : #accessing }
GtRlProjectsLoadWorkflow >> rootLoadDirective: aLoadDirective [
	rootLoadDirective := aLoadDirective.
	self updateLoadActions
]

{ #category : #updating }
GtRlProjectsLoadWorkflow >> updateLoadActions [
	loadActions := OrderedCollection new.
	visitedLoadDirectives := Set new.
	self updateLoadActionsFor: self rootLoadDirective
]

{ #category : #updating }
GtRlProjectsLoadWorkflow >> updateLoadActionsFor: aLoadDirective [
	(visitedLoadDirectives includes: aLoadDirective) ifTrue: [ ^ self ].
	visitedLoadDirectives add: aLoadDirective.

	aLoadDirective preLoadAction ifNotNil: [
		loadActions add: aLoadDirective preLoadAction ].
	
	aLoadDirective childLoadDirectives do: [ :aChildLoadDirective |
		self updateLoadActionsFor: aChildLoadDirective ].
	loadActions addAll: aLoadDirective packageLoadActions.
	
	aLoadDirective postLoadAction ifNotNil: [
		loadActions add: aLoadDirective postLoadAction ].
]
