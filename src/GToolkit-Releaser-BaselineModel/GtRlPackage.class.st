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
		'outgoingDependencies'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlPackage class >> withName: aPackageName [
	^ self new
		name: aPackageName
]

{ #category : #adding }
GtRlPackage >> addOutgoingDependency: aDependency [
	self assert: [ aDependency notNil ].
	self 
		assert: [ aDependency sourceNode == self] 
		description: 'Within an outgoing dependency the current node should be the source'.
	
	self outgoingDependencies add: aDependency
]

{ #category : #converting }
GtRlPackage >> asRPackage [
	[^ self name asPackage] on: NotFound do:[ ^ nil ]
]

{ #category : #ui }
GtRlPackage >> gtViewDependentPackagesListFor: aView [
	<gtView>
	^ aView list
		title: 'Dependent packages' translated;
		priority: 60;
		items: [ self dependentPackages ];
		itemFormat: #name
]

{ #category : #ui }
GtRlPackage >> gtViewIncomingDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Incoming Dependencies' translated;
		priority: 90;
		items: [ self incomingDependencies ]
]

{ #category : #ui }
GtRlPackage >> gtViewOutgoingDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Outgoing Dependencies' translated;
		priority: 92;
		items: [ self outgoingDependencies ]
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredPackagesListFor: aView [
	<gtView>
	^ aView list
		title: 'Required packages' translated;
		priority: 50;
		items: [ self requiredPackages ];
		itemFormat: #name
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Required projects' translated;
		priority: 55;
		items: [ self requiredProjectReferences ];
		itemFormat: #name
]

{ #category : #initialization }
GtRlPackage >> initialize [ 	
	super initialize.
	outgoingDependencies := OrderedCollection new.
]

{ #category : #testing }
GtRlPackage >> isPackageNode [
	^ true
]

{ #category : #accessing }
GtRlPackage >> outgoingDependencies [
	^ outgoingDependencies
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> outgoingPackageDependencies [
	^ self outgoingDependencies select: [ :aDependency |
		aDependency targetNode isPackageNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> outgoingProjectDependencies [
	^ self outgoingDependencies select: [ :aDependency |
		aDependency targetNode isProjectReference ]
]

{ #category : #accessing }
GtRlPackage >> repository [
	^ self parentProject ifNotNil: [ :aProject | 
		aProject repository ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> requiredNodes [
	^ self outgoingDependencies collect: [ :aDependency |
		aDependency targetNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> requiredPackages [
	^ self outgoingPackageDependencies collect: [ :aDependency |
		aDependency targetNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> requiredProjectReferences [
	^ self outgoingProjectDependencies collect: [ :aDependency |
		aDependency targetNode ]
]
