"
I model a package that is loaded by a project.

I have as main attributes:
	- the name of the package 
	- the project that contains me
	- dependencies to other packages or projects
	
I do not have an explicit repository. I am placed in the same repository as the project that contains me.
"
Class {
	#name : #GtRlPackage,
	#superclass : #GtRlNode,
	#instVars : [
		'dependencies',
		'parentProject'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlPackage class >> withName: aPackageName [
	^ self new
		name: aPackageName
]

{ #category : #adding }
GtRlPackage >> addDependencies: aCollectionOfDependencies [
	self dependencies addAll: aCollectionOfDependencies
]

{ #category : #converting }
GtRlPackage >> asRPackage [
	[^ self name asPackage] on: NotFound do:[ ^ nil ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> dependencies [
	^ dependencies
]

{ #category : #ui }
GtRlPackage >> gtViewDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Dependencies' translated;
		items: [ self dependencies ];
		priority: 60
]

{ #category : #initialization }
GtRlPackage >> initialize [ 	
	super initialize.
	dependencies := OrderedCollection new
]

{ #category : #accessing }
GtRlPackage >> parentProject [
	^ parentProject
]

{ #category : #accessing }
GtRlPackage >> parentProject: aProject [
	parentProject := aProject
]

{ #category : #printing }
GtRlPackage >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlPackage >> repository [
	^ self parentProject ifNotNil: [ :aProject | 
		aProject repository ]
]
