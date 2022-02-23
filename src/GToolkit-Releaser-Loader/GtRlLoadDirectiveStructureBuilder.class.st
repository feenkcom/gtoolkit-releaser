Class {
	#name : #GtRlLoadDirectiveStructureBuilder,
	#superclass : #Object,
	#instVars : [
		'loadDirectivesMap'
	],
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : #building }
GtRlLoadDirectiveStructureBuilder >> buildLoadDirectiveForProject: aProject [
	| loadDirective |
	self assert: [ (self loadDirectivesMap includesKey: aProject) not ].
	
	loadDirective := GtRlProjectLoadDirective forProject: aProject.
	self loadDirectivesMap 
		at: aProject 
		put: loadDirective.
	
	self createChildrenForLoadDirective: loadDirective.
	
	^ loadDirective
]

{ #category : #'private building' }
GtRlLoadDirectiveStructureBuilder >> createChildrenForLoadDirective: loadDirective [
	"We ignore relations to child projects that have already been added to the load directive.
	So we just add a project to the load directive the first time we encounter it, 
	even if multiple projects referenced it."
	loadDirective project childProjects do: [ :aChildProject |
		| childLoadDirective |
		(self loadDirectivesMap includesKey: aChildProject) 
			ifFalse: [ 
				childLoadDirective := self buildLoadDirectiveForProject: aChildProject.
				loadDirective addChildLoadDirective: childLoadDirective ]
			ifTrue: [
				childLoadDirective := self loadDirectivesMap at: aChildProject.
				loadDirective addIgnoredChildLoadDirective: childLoadDirective ]  ]
]

{ #category : #accessing }
GtRlLoadDirectiveStructureBuilder >> loadDirectivesMap [
	^ loadDirectivesMap ifNil: [ 
		loadDirectivesMap := Dictionary new ]
]
