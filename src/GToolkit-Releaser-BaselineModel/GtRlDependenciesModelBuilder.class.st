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
	#category : #'GToolkit-Releaser-BaselineModel-Builder'
}

{ #category : #assertions }
GtRlDependenciesModelBuilder >> assertBaselineMethodIn: aBaselineClass [
	self
		assert: [ aBaselineClass includesSelector: #baseline: ]
		description: [ 'Baseline class named {1} must include #baseline: selector'
				format: {aBaselineClass} ].
	self
		assert: [ aBaselineClass >> #baseline: hasPragmaNamed: #baseline ]
		description: [ 'Baseline method {1} >> #baseline: must have <baseline> pragma.'
				format: {aBaselineClass} ]
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
	| targetVersions newProject |
	
	targetVersions := self 
		forPharo12: [ 
			(aMetacelloProjectSpec className asClassInEnvironment:
		         self class environment) project versions.] 
		forPharo11AndPharo10: [ 
			aMetacelloProjectSpec project versions ].
	 
	self assert: [ targetVersions size = 1 ].
	self assert: [ aMetacelloProjectSpec repositorySpecs size = 1 ].
	self assertBaselineMethodIn: aMetacelloProjectSpec projectClass.

	"If the project was already created return the existing project.
	This does not initialize any dependencies as it assumes they are already initialized."
	(self projectsByBaselineClass includesKey:
		 aMetacelloProjectSpec projectClass) ifTrue: [
		^ self projectsByBaselineClass at:
			  aMetacelloProjectSpec projectClass ].
			  
	"If this is the first time the project is encountered, create it and initalize its dependencies"
	newProject := self instantiateProjectFromMetacelloSpec: aMetacelloProjectSpec.
	self updateDependenciesFor: newProject fromMCVersion: (self 
		forPharo12: [ targetVersions first ] 
		forPharo11AndPharo10: [ aMetacelloProjectSpec version ] ).
	
	"Only add the project to the "
	self projectsByBaselineClass
		at: aMetacelloProjectSpec projectClass
		put: newProject.

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
	| repositoriesSpec project |
	repositoriesSpec := self 
		forPharo12: [ aBaselineProjectSpec repositories ] 
		forPharo11AndPharo10: [ aBaselineProjectSpec version spec repositories ].

	self assert: [ repositoriesSpec map size = 1 ].
	
	project := GtRlProject new 
		name: (MetacelloScriptEngine baseNameOf: aBaselineProjectSpec projectClass name);
		baselineClass: aBaselineProjectSpec projectClass;
		linkWithRepository: (self ensureRepositoriesFor: repositoriesSpec map values first description).
		
	self 
		forPharo12: [ 
			project baselineVersion: (aBaselineProjectSpec className
				asClassInEnvironment:
		        	self class environment) project versions first ] 
		forPharo11AndPharo10: [ 
			project baselineVersion: aBaselineProjectSpec version ].
	
	^ project
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
		packagesByName at: aReleaserPackage name asString put: aReleaserPackage ].
	currentProject projectReferences do: [ :aProjectReference |
		projectReferencesByName 
			at: aProjectReference name asString
			put: aProjectReference ].
	
	aMetacelloVersion packages do: [ :aMetacelloPackageSpec | 
		| currentPackage |
		currentPackage := packagesByName 
			at: aMetacelloPackageSpec name asString.
		aMetacelloPackageSpec requires do: [ :aRequirementName | 
			packagesByName 
				at: aRequirementName asString
				ifPresent: [ :aTargetPackage | 
					self 
						createDependencyFromPackage: currentPackage 
						toNode: aTargetPackage ]
				ifAbsent: [ projectReferencesByName 
					at: aRequirementName asString
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
			select: [ :aMetacelloProjectSpec | 
				| targetVersion shouldKeep |
				targetVersion := self
						forPharo12: [ | class |
							class := aMetacelloProjectSpec className
									asClassInEnvironment: self class environment
									ifAbsent: [ nil ].
							"we check here in case we have a BaselineOfX reference for which the class is not yet in the image"
							class
								ifNotNil: [  :c | c project versions first ] ]
						forPharo11AndPharo10: [ aMetacelloProjectSpec version ].
				shouldKeep := targetVersion notNil and: [ targetVersion name = 'baseline' ].

				shouldKeep
					ifFalse: [ StringSignal
							emit: 'Ignoring dependency ' , aMetacelloProjectSpec className , ' of '
									, currentProject name ].
				shouldKeep ])
			collect: [ :aMCProjectSpec | 
				| referencedProject |
				referencedProject := self buildProjectFromMetacelloSpec: aMCProjectSpec.
				GtRlProjectReference new referencedProject: referencedProject ].
	currentProject addProjectReferences: projectReferences
]
