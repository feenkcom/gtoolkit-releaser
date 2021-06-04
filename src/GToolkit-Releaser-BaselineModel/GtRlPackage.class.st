"
I model a package that is loaded by a project. 

I have as main attributes:
	- the name of the package 
	- the project that contains me
	- outgoing dependencies to other packages or projects
	- incomming dependencies from other packages that depend on me
	
I do not have an explicit repository. I am placed in the same repository as the project that contains me. Also packages are internal to the project and should not be referenced from other projects. Dependencies should only be at the level of projects.


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
		itemText: #name
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredProjectReferencesListFor: aView [
	<gtView>
	^ aView list
		title: 'Project References' translated;
		priority: 56;
		items: [ self requiredProjectReferences ];
		itemText: #name
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Required projects' translated;
		priority: 55;
		items: [ self requiredProjects ];
		itemText: #name
]

{ #category : #accessing }
GtRlPackage >> icebergPackage [
	^ self icebergRepository workingCopy packageNamed: self name
]

{ #category : #accessing }
GtRlPackage >> icebergRepository [
	^ self parentProject repository icebergRepository
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
GtRlPackage >> outgoingDependenciesToPackages [
	^ self outgoingDependencies select: [ :aDependency |
		aDependency targetNode isPackageNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> outgoingDependenciesToProjects [
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
	^ self outgoingDependenciesToPackages collect: [ :aDependency |
		aDependency targetNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> requiredProjectReferences [
	^ self outgoingDependenciesToProjects collect: [ :aDependency |
		aDependency targetNode ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> requiredProjects [
	^ self requiredProjectReferences collect: [ :aProjectReference |
		aProjectReference referencedProject ]
]
