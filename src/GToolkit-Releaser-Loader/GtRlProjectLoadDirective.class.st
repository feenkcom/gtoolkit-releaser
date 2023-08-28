Class {
	#name : #GtRlProjectLoadDirective,
	#superclass : #Object,
	#instVars : [
		'project',
		'parentLoadDirectives',
		'childLoadDirectives',
		'ignoredChildLoadDirectives',
		'preLoadAction',
		'postLoadAction',
		'packageLoadActions'
	],
	#category : #'GToolkit-Releaser-Loader-Core'
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
GtRlProjectLoadDirective >> addIgnoredChildLoadDirective: aLoadDirective [
	self ignoredChildLoadDirectives add: aLoadDirective
	
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

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewBaselineCodeFor: aView [
	<gtView>
	^ aView forward 
		title: 'Code' translated;
		priority: 35;
		object: [ self project baselineClass >> #baseline: ];
		view: #gtSourceFor: 
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewChildLoadDirectivesFor: aView [
	<gtView>
	^ aView list 
		title: 'Child directives' translated;
		priority: 15;
		items: [ self childLoadDirectives ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewLoadDirectivesTreesFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Directives tree' translated;
		priority: 16;
		items: [ {self} ];
		expandUpTo: 2;
		children: [ :aLoadDirective | aLoadDirective childLoadDirectives ];
		column: 'Type' text: [ :aDirective | aDirective className ];
		column: 'Component' text: [ :aDirective | aDirective projectName ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewLocalLoadActionsFor: aView [
	<gtView>
	^ aView list 
		title: 'Local actions' translated;
		priority: 25;
		items: [ self loadActions ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewPackagesFor: aView [
	<gtView>
	^ aView list 
		title: 'Packages' translated;
		priority: 30;
		items: [ self packagesInLoadOrder ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtViewParentLoadDirectivesFor: aView [
	<gtView>
	^ aView list 
		title: 'Parent directives' translated;
		priority: 20;
		items: [ self parentLoadDirectives ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> ignoredChildLoadDirectives [
	^ ignoredChildLoadDirectives ifNil: [ 
		ignoredChildLoadDirectives := OrderedCollection new ]
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
	
	self packagesInLoadOrder do: [ :aPackage | 
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
	
	loadActions addAll: self packageLoadActions.
	
	self postLoadAction ifNotNil: [ :anAction |
		loadActions add: anAction ].
	
	^ loadActions
]

{ #category : #accessing }
GtRlProjectLoadDirective >> packageLoadActions [
	^ packageLoadActions ifNil: [ 
		packageLoadActions := OrderedCollection new ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> packagesInLoadOrder [
	^ GtRlPackagesLoadOrderTraversal new 
		packagesLoadOrderFor: self project
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

{ #category : #accessing }
GtRlProjectLoadDirective >> withAllChildActiveAndIgnoredLoadDirectived [
	^ self withDeepCollect: [ :aLoadDirective | 
		aLoadDirective childLoadDirectives, aLoadDirective ignoredChildLoadDirectives ]
]

{ #category : #accessing }
GtRlProjectLoadDirective >> withAllChildIgnoredLoadDirectived [
	^ self withDeepCollect: #ignoredChildLoadDirectives
]

{ #category : #accessing }
GtRlProjectLoadDirective >> withAllChildLoadDirectived [
	^ self withDeepCollect: #childLoadDirectives
]
