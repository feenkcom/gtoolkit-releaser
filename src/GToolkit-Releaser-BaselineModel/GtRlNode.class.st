"
I am an abstraction for a type of dependency in the loading configuration of a system.

I hold a list of incomming dependencies that indicate what other nodes in the baseline depend on me. Currently those dependencies are only of type {{gtClass:GtRlPackageDependency}}, as only packages can have outgoing dependencies.


"
Class {
	#name : #GtRlNode,
	#superclass : #Object,
	#instVars : [
		'name',
		'parentProject',
		'incomingDependencies'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #adding }
GtRlNode >> addIncomingDependency: aDependency [
	self assert: [ aDependency notNil ].
	self 
		assert: [ aDependency targetNode == self ] 
		description: 'Within an incoming dependency the current node should be the target'.
	
	self incomingDependencies add: aDependency
]

{ #category : #'accessing - dynamic' }
GtRlNode >> dependentPackages [
	^ self incomingDependenciesFromPackages collect: [ :aDependency |
		aDependency sourceNode ]
]

{ #category : #ui }
GtRlNode >> gtViewDependentPackagesListFor: aView [
	<gtView>
	^ aView list
		title: 'Dependent packages' translated;
		priority: 60;
		items: [ self dependentPackages ];
		itemText: #name
]

{ #category : #ui }
GtRlNode >> gtViewIncomingDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Incoming dependencies' translated;
		priority: 90;
		items: [ self incomingDependencies ]
]

{ #category : #accessing }
GtRlNode >> incomingDependencies [
	^ incomingDependencies
]

{ #category : #'accessing - dynamic' }
GtRlNode >> incomingDependenciesFromPackages [
	^ self incomingDependencies select: [ :aDependency |
		aDependency sourceNode isPackageNode ]
]

{ #category : #initialization }
GtRlNode >> initialize [
	super initialize.
	incomingDependencies := OrderedCollection new.
]

{ #category : #testing }
GtRlNode >> isPackageNode [
	^ false
]

{ #category : #testing }
GtRlNode >> isProjectReference [
	^ false
]

{ #category : #testing }
GtRlNode >> isUnknownNode [
	^ false
]

{ #category : #accessing }
GtRlNode >> name [
	^ name
]

{ #category : #accessing }
GtRlNode >> name: aString [
	self assert: [ aString notNil ].
	self 
		assert: [ name isNil ]
		description: 'The name of a node is immutable'.  
	
	name := aString
]

{ #category : #accessing }
GtRlNode >> parentProject [
	^ parentProject
]

{ #category : #accessing }
GtRlNode >> parentProject: aProject [
	self assert: [ aProject notNil ].
	self 
		assert: [ parentProject isNil ]
		description: 'The parent of a node is immutable'.  
	
	parentProject := aProject
]

{ #category : #printing }
GtRlNode >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]
