Class {
	#name : #GtRlLoadDirectiveStructureBuilder,
	#superclass : #Object,
	#instVars : [
		'loadDirectivesMap'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #building }
GtRlLoadDirectiveStructureBuilder >> buildLoadDirectiveForProject: aProject [
	| loadDirective |
	loadDirective := GtRlProjectLoadDirective forProject: aProject.
	self loadDirectivesMap 
		at: aProject 
		put: loadDirective.
	
	self createChildrenForLoadDirective: loadDirective.
	
	^ loadDirective
]

{ #category : #'private building' }
GtRlLoadDirectiveStructureBuilder >> createChildrenForLoadDirective: loadDirective [.
	loadDirective project childProjects do: [ :aChildProject |
		| childLoadDirective |
		childLoadDirective := self loadDirectivesMap
			at: aChildProject
			ifAbsent: [ self buildLoadDirectiveForProject: aChildProject ].
		loadDirective addChildLoadDirective: childLoadDirective ]
]

{ #category : #accessing }
GtRlLoadDirectiveStructureBuilder >> loadDirectivesMap [
	^ loadDirectivesMap ifNil: [ 
		loadDirectivesMap := Dictionary new ]
]
