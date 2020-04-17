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
		'incomingDependencies',
		'outgoingDependencies',
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
GtRlPackage >> addIncomingDependency: aDependency [
	self assert: [ aDependency notNil ].
	self 
		assert: [ aDependency targetNode == self] 
		description: 'Within an incoming dependency the current node should be the target'.
	
	self incomingDependencies add: aDependency
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

{ #category : #'accessing - dynamic' }
GtRlPackage >> dependentPackages [
	^ self incomingPackageDependencies collect: [ :aDependency |
		aDependency sourceNode ]
]

{ #category : #ui }
GtRlPackage >> gtViewDependentPackagesListFor: aView [
	<gtView>
	^ aView list
		title: 'Dependent packages' translated;
		items: [ self dependentPackages ];
		itemFormat: #name;
		priority: 60
]

{ #category : #ui }
GtRlPackage >> gtViewIncomingDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Incoming Dependencies' translated;
		items: [ self incomingDependencies ];
		priority: 90
]

{ #category : #ui }
GtRlPackage >> gtViewOutgoingDependenciesListFor: aView [
	<gtView>
	^ aView list
		title: 'Outgoing Dependencies' translated;
		items: [ self outgoingDependencies ];
		priority: 92
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredPackagesListFor: aView [
	<gtView>
	^ aView list
		title: 'Required packages' translated;
		items: [ self requiredPackages ];
		itemFormat: #name;
		priority: 50
]

{ #category : #ui }
GtRlPackage >> gtViewRequiredProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Required projects' translated;
		items: [ self requiredProjects ];
		itemFormat: #name;
		priority: 55
]

{ #category : #accessing }
GtRlPackage >> incomingDependencies [
	^ incomingDependencies
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> incomingPackageDependencies [
	^ self incomingDependencies select: [ :aDependency |
		aDependency targetNode isPackageModel ]
]

{ #category : #initialization }
GtRlPackage >> initialize [ 	
	super initialize.
	incomingDependencies := OrderedCollection new.
	outgoingDependencies := OrderedCollection new.
]

{ #category : #testing }
GtRlPackage >> isPackageModel [
	^ true
]

{ #category : #accessing }
GtRlPackage >> outgoingDependencies [
	^ outgoingDependencies
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> outgoingPackageDependencies [
	^ self outgoingDependencies select: [ :aDependency |
		aDependency targetNode isPackageModel ]
]

{ #category : #'accessing - dynamic' }
GtRlPackage >> outgoingProjectDependencies [
	^ self outgoingDependencies select: [ :aDependency |
		aDependency targetNode isProjectModel ]
]

{ #category : #accessing }
GtRlPackage >> parentProject [
	^ parentProject
]

{ #category : #accessing }
GtRlPackage >> parentProject: aProject [
	parentProject := aProject
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
GtRlPackage >> requiredProjects [
	^ self outgoingProjectDependencies collect: [ :aDependency |
		aDependency targetNode ]
]
