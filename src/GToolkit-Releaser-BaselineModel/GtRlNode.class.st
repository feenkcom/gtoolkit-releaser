"
I am an abstraction for a type of dependency in the loading configuration of a system.
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
		assert: [ aDependency targetNode == self] 
		description: 'Within an incoming dependency the current node should be the target'.
	
	self incomingDependencies add: aDependency
]

{ #category : #'accessing - dynamic' }
GtRlNode >> dependentPackages [
	^ self incomingPackageDependencies collect: [ :aDependency |
		aDependency sourceNode ]
]

{ #category : #accessing }
GtRlNode >> incomingDependencies [
	^ incomingDependencies
]

{ #category : #'accessing - dynamic' }
GtRlNode >> incomingPackageDependencies [
	^ self incomingDependencies select: [ :aDependency |
		aDependency targetNode isPackageNode ]
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
