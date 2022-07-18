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
GtRlProjectLoadDirective >> gtFullLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Load map (full)' translated;
		priority: 10;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aLoadDirective |
					BrLabel new 
						text: aLoadDirective projectName; 
						aptitude: (BrGlamorousLabelAptitude new 
							in: [ :anAptitude |
								aLoadDirective = self ifTrue: [
									anAptitude bold ].
								anAptitude ]);
						when: BlClickEvent do: [ :anEvent | 
							anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: (self withAllChildActiveAndIgnoredLoadDirectived) removeDuplicates.
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color blue alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian edges
				passive;
				shape: [ 
					BlParabollaArcElement new 
						zIndex: -1;
						curvatureFraction: 0.3;
						border: (BlBorder paint: (Color lightGray alpha: 0.5) width: 1);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color lightGray alpha: 0.5); width: 1; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #ignoredChildLoadDirectives.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Load map' translated;
		priority: 1;
		painting: [ :mondrian | 
			mondrian nodes
				shape: [ :aLoadDirective | 
					BrLabel new
						text: aLoadDirective projectName;
						when: BlClickEvent
							do: [ :anEvent | anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: self withAllChildLoadDirectived.
			mondrian edges
				shape: [ BlLineElement new
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
								border: (BlBorder builder
										paint: (Color blue alpha: 0.5);
										width: 2;
										build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian layout custom: GtGradWestHierarchicalLayout new ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtParentLoadDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Parents Chain' translated;
		priority: 20;
		painting: [ :mondrian | 
			mondrian nodes
				shape: [ :aLoadDirective | 
					BrLabel new
						text: aLoadDirective projectName;
						when: BlClickEvent
							do: [ :anEvent | anEvent currentTarget phlow spawnObject: aLoadDirective ] ];
				with: (self withDeepCollect: #parentLoadDirectives).
			mondrian edges
				shape: [ BlLineElement new
						zIndex: -1;
						border: (BlBorder paint: (Color blue alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
								border: (BlBorder builder
										paint: (Color blue alpha: 0.5);
										width: 2;
										build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childLoadDirectives.
			mondrian layout custom: GtGradWestHierarchicalLayout new ]
]

{ #category : #'gt-extensions' }
GtRlProjectLoadDirective >> gtProjectWithDirectivesMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 11;
		painting: [ :mondrian | 
			| projectEdges |
			projectEdges := OrderedCollection new.
			self
				withDeep: #childLoadDirectives
				edgesDo: [ :from :to | projectEdges add: from project -> to project ].
			mondrian nodes
				shape: [ :aProject | 
					BrLabel new
						text: aProject name;
						in: [ :label | label userData at: #projectModel put: aProject ];
						yourself ];
				with: self project withAllChildProjects.
			mondrian edges
				shape: [ :each :fromElement :toElement | 
					| isInLoadDirective |
					isInLoadDirective := projectEdges
							anySatisfy: [ :anEdge | 
								anEdge key = (fromElement userData at: #projectModel)
									and: [ anEdge value = (toElement userData at: #projectModel) ] ].
					BlLineElement new
						zIndex: -1;
						border: (isInLoadDirective
								ifTrue: [ BlBorder paint: (Color blue alpha: 0.5) width: 2 ]
								ifFalse: [ BlBorder paint: (Color gray alpha: 0.5) width: 1 ]);
						toHead: (BlArrowheadSimpleArrow new
								border: (isInLoadDirective
										ifTrue: [ BlBorder builder
												paint: (Color blue alpha: 0.5);
												width: 2;
												build ]
										ifFalse: [ BlBorder builder
												paint: (Color gray alpha: 0.5);
												width: 1;
												build ])) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childProjects.
			mondrian layout custom: GtGradWestHierarchicalLayout new ]
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
