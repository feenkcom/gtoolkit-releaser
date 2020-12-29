Class {
	#name : #GtRlProjectLoadDirective,
	#superclass : #Object,
	#instVars : [
		'project',
		'parentLoadDirectives',
		'childLoadDirectives',
		'preLoadAction',
		'postLoadAction',
		'packageLoadActions'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #'instance creation' }
GtRlProjectLoadDirective class >> forProject: aProject [ 
	^ self new
		initializeForProject: aProject
]

{ #category : #adding }
GtRlProjectLoadDirective >> addChildLoadDirective: aLoadDirective [
	aLoadDirective parentLoadDirectives add: self.
	self childLoadDirectives add: aLoadDirective
	
]

{ #category : #adding }
GtRlProjectLoadDirective >> addPackageAction: aPackageAction [
	self assert: [ aPackageAction notNil ].
	
	self packageLoadActions add: aPackageAction
]

{ #category : #accessing }
GtRlProjectLoadDirective >> childLoadDirectives [
	^ childLoadDirectives ifNil: [ 
		childLoadDirectives := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
GtRlProjectLoadDirective >> gtViewChildLoadDirectivesFor: aView [
	<gtView>
	^ aView list 
		title: 'Child directives' translated;
		priority: 15;
		items: [ self childLoadDirectives ]
]

{ #category : #'as yet unclassified' }
GtRlProjectLoadDirective >> gtViewLocalLoadActionsFor: aView [
	<gtView>
	^ aView list 
		title: 'Local actions' translated;
		priority: 25;
		items: [ self loadActions ]
]

{ #category : #'as yet unclassified' }
GtRlProjectLoadDirective >> gtViewParentLoadDirectivesFor: aView [
	<gtView>
	^ aView list 
		title: 'Parent directives' translated;
		priority: 20;
		items: [ self parentLoadDirectives ]
]

{ #category : #initialization }
GtRlProjectLoadDirective >> initializeForProject: aProject [
	self assert: [ aProject notNil and: [ project isNil ] ].
	
	project := aProject.
	self initializeLoadActions.
]

{ #category : #updating }
GtRlProjectLoadDirective >> initializeLoadActions [
	self assert: [ self preLoadAction isNil ].
	self assert: [ self postLoadAction isNil ].
	self assert: [ self packageLoadActions isEmpty ].
	
	self project hasPreLoadActionSpecified ifTrue: [
		preLoadAction := GtRlPreLoadAction new 	
			loadDirective: self ].
	self project hasPostLoadActionSpecified ifTrue: [
		postLoadAction := GtRlPostLoadAction new 	
			loadDirective: self ].
	
	self project packages do: [ :aPackage | 
		self addPackageAction: (GtRlPackageLoadAction new
			package: aPackage;
			loadDirective: self) ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> loadActions [
	| loadActions |
	loadActions := OrderedCollection new.
	self preLoadAction ifNotNil: [ :anAction |
		loadActions add: anAction ].
	self postLoadAction ifNotNil: [ :anAction |
		loadActions add: anAction ].
	
	loadActions addAll: self packageLoadActions.
	^ loadActions
]

{ #category : #accessing }
GtRlProjectLoadDirective >> packageLoadActions [
	^ packageLoadActions ifNil: [ 
		packageLoadActions := OrderedCollection new ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> parentLoadDirectives [
	^ parentLoadDirectives ifNil: [ 
		parentLoadDirectives := OrderedCollection new ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> postLoadAction [
	^ postLoadAction
]

{ #category : #accessing }
GtRlProjectLoadDirective >> preLoadAction [
	^ preLoadAction
]

{ #category : #printing }
GtRlProjectLoadDirective >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self projectName.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
GtRlProjectLoadDirective >> project [
	^ project
]

{ #category : #accessing }
GtRlProjectLoadDirective >> projectName [
	^ self project name
]
