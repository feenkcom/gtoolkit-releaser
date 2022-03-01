"
I build the graph of projects and repositories for a given Metacello baseline. The constructed graph represents the loading configurations for the given baseline used by Releaser.

I only work with Metacello baselines that:
	- have no cycles in the loading configuration 
	- do not use groups
	- do not use explicit repositories for packages
	- only use the #'common' spec


"
Class {
	#name : #GtRlDependenciesModelBuilder,
	#superclass : #Object,
	#instVars : [
		'projectsByBaselineClass',
		'repositoriesByUrl',
		'projectsChain'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Builder'
}

{ #category : #assertions }
GtRlDependenciesModelBuilder >> assertBaselineMethodIn: aBaselineClass [
	self assert: [ aBaselineClass includesSelector: #baseline: ].
	self assert: [ (aBaselineClass >> #baseline:) hasPragmaNamed: #baseline ]
]

{ #category : #building }
GtRlDependenciesModelBuilder >> buildProjectFromBaselineClass: aBaselineClass withRepositoryDescription: aRepositoryUrl [
	| newProject mcVersion |
	self assert: [ aBaselineClass project versions size = 1 ].
	
	mcVersion := aBaselineClass project versions first.
	newProject := GtRlProject new
		name: (MetacelloScriptEngine baseNameOf: aBaselineClass name); 
		baselineVersion: mcVersion;
		baselineClass: aBaselineClass;
		linkWithRepository: (self ensureRepositoriesFor: aRepositoryUrl).
	
	self updateDependenciesFor: newProject fromMCVersion: mcVersion.
	self projectsByBaselineClass at: aBaselineClass put: newProject.
	
	^ newProject
]

{ #category : #building }
GtRlDependenciesModelBuilder >> buildProjectFromMetacelloSpec: aMetacelloProjectSpec [
	| newProject |
	self assert: [ aMetacelloProjectSpec project versions size = 1 ].
	self assert: [ aMetacelloProjectSpec repositorySpecs size = 1 ].
	self assertBaselineMethodIn: aMetacelloProjectSpec projectClass.
	
	"If the project was already created return the existing project.
	This does not initialize any dependencies as it assumes they are already initialized."
	(self projectsByBaselineClass includesKey: aMetacelloProjectSpec projectClass)
		ifTrue: [ ^ self projectsByBaselineClass at: aMetacelloProjectSpec projectClass ]
	
	"If this is the first time the project is encountered, create it and initalize its dependencies".
	newProject := self instantiateProjectFromMetacelloSpec: aMetacelloProjectSpec.
	self 
		updateDependenciesFor: newProject 
		fromMCVersion: aMetacelloProjectSpec version.
	
	"Only add the project to the "
	self projectsByBaselineClass at: aMetacelloProjectSpec projectClass put: newProject.
	
	^ newProject
]

{ #category : #'private - building' }
GtRlDependenciesModelBuilder >> createDependencyFromPackage: aSourcePackage toNode: aTargetNode [
	| dependency |
	dependency := GtRlPackageDependency new
		sourceNode: aSourcePackage;
		targetNode: aTargetNode.
	aSourcePackage addOutgoingDependency: dependency.
	aTargetNode addIncomingDependency: dependency
]

{ #category : #'private - building' }
GtRlDependenciesModelBuilder >> ensureRepositoriesFor: aRepositoryUrl [
	^ repositoriesByUrl 
		at: aRepositoryUrl 
		ifAbsentPut: [ 
			GtRlRepository fromUrlString: aRepositoryUrl ]
]

{ #category : #initialize }
GtRlDependenciesModelBuilder >> initialize [ 
	super initialize.
	projectsByBaselineClass := IdentityDictionary new.
	repositoriesByUrl := Dictionary new.
	projectsChain := OrderedCollection new.
]

{ #category : #'private - building' }
GtRlDependenciesModelBuilder >> instantiatePackageFromMetacelloSpec: aMetacelloPackageSpec [
	^ GtRlPackage new
		name: aMetacelloPackageSpec name
]

{ #category : #'private - building' }
GtRlDependenciesModelBuilder >> instantiateProjectFromMetacelloSpec: aBaselineProjectSpec [
	| repositoriesSpec |
	repositoriesSpec := aBaselineProjectSpec version spec repositories.
	self assert: [ repositoriesSpec map size = 1 ].
	^ GtRlProject new 
		name: (MetacelloScriptEngine baseNameOf: aBaselineProjectSpec projectClass name);
		baselineVersion: aBaselineProjectSpec version;
		baselineClass: aBaselineProjectSpec projectClass;
		linkWithRepository: (self ensureRepositoriesFor: repositoriesSpec map values first description) 
]

{ #category : #accessing }
GtRlDependenciesModelBuilder >> projectsByBaselineClass [
	^ projectsByBaselineClass
]

{ #category : #dependencies }
GtRlDependenciesModelBuilder >> resolvePackageDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| packagesByName projectReferencesByName |
	packagesByName := Dictionary new.
	projectReferencesByName := Dictionary new.
	"Create two dictionaries with all possible package and project dependencies"
	currentProject packages do: [ :aReleaserPackage |
		packagesByName at: aReleaserPackage name put: aReleaserPackage ].
	currentProject projectReferences do: [ :aProjectReference |
		projectReferencesByName at: aProjectReference name put: aProjectReference ].
	
	aMetacelloVersion packages do: [ :aMetacelloPackageSpec | 
		| currentPackage |
		currentPackage := packagesByName at: aMetacelloPackageSpec name.
		aMetacelloPackageSpec requires do: [ :aRequirementName | 
			packagesByName 
				at: aRequirementName 
				ifPresent: [ :aTargetPackage | 
					self 
						createDependencyFromPackage: currentPackage 
						toNode: aTargetPackage ]
				ifAbsent: [ projectReferencesByName 
					at: aRequirementName
					ifPresent: [ :aTargetProjectReference |
						self 
							createDependencyFromPackage: currentPackage 
							toNode: aTargetProjectReference ]
					ifAbsent: [ 
						self 
							createDependencyFromPackage: currentPackage 
							toNode: (GtRlUnknownNode withName: aRequirementName) ] ] ] ].
]

{ #category : #dependencies }
GtRlDependenciesModelBuilder >> updateDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	self 
		updateProjectDependenciesFor: currentProject 
		fromMCVersion: aMetacelloVersion.
	self 
		updatePackageDependenciesFor: currentProject
		fromMCVersion: aMetacelloVersion
]

{ #category : #dependencies }
GtRlDependenciesModelBuilder >> updatePackageDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| newPackages |
	newPackages := aMetacelloVersion packages collect: [ :aMetacelloPackageSpec |
		self instantiatePackageFromMetacelloSpec: aMetacelloPackageSpec ].
	currentProject addPackages: newPackages.
	
	self resolvePackageDependenciesFor: currentProject fromMCVersion: aMetacelloVersion
]

{ #category : #dependencies }
GtRlDependenciesModelBuilder >> updateProjectDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| projectReferences |
	projectReferences := (aMetacelloVersion projects 
		select: [ :aMetacelloProjectSpec || shouldKeep |
			shouldKeep := aMetacelloProjectSpec version notNil and: [ 
				aMetacelloProjectSpec version name = 'baseline' ].
			shouldKeep ifFalse: [ 
				StringSignal emit: ('Ignoring dependency ', aMetacelloProjectSpec className, ' of ', currentProject name) ].
			shouldKeep ])
		collect: [ :aMCProjectSpec | 
			| referencedProject |
			referencedProject := self buildProjectFromMetacelloSpec: aMCProjectSpec.
			GtRlProjectReference new 
				referencedProject: referencedProject ].
	currentProject addProjectReferences: projectReferences.
]
