Class {
	#name : #GtRlPackageExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoDependencies [
	<gtExample>
	| package |
	package :=self packageWithName.
	self assert: package outgoingDependencies isEmpty.	
	self assert: package incomingDependencies isEmpty.
	self assert: package incomingPackageDependencies isEmpty.
	self assert: package outgoingPackageDependencies isEmpty.
	self assert: package outgoingProjectDependencies isEmpty.
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoPackagedAndProjects [
	<gtExample>
	| package |
	package :=self packageWithName.
	self assert: package requiredPackages isEmpty.	
	self assert: package requiredProjects isEmpty.
	self assert: package dependentPackages isEmpty.
	
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoProject [
	<gtExample>
	| package |
	package :=self packageWithName.
	self assert: package parentProject isNil.
	self assert: package repository isNil.
	^ package
]

{ #category : #'examples - incoming' }
GtRlPackageExamples >> packageWithIncomingPackageDependencies [
	<gtExample>
	| package packageA packageB |
	package := self packageWithName.
	packageA := GtRlPackage withName: 'PackageA'.
	packageB := GtRlPackage withName: 'PackageB'.
	package addIncomingDependency: (GtRlDependency new 
		sourceNode: packageA;
		targetNode: package).
	package addIncomingDependency: (GtRlDependency new 
		sourceNode: packageB;
		targetNode: package).
	
	self assert: package incomingDependencies size equals: 2.
	self assert: package incomingPackageDependencies size equals: 2.
	self assert: package dependentPackages first equals: packageA.
	self assert: package dependentPackages second equals: packageB.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithMixedOutgoingDependencies [
	<gtExample>
	| package unknownNode projectA packageA |
	unknownNode := GtRlUnknownNode withName: 'Unknown'.
	projectA := GtRlProject withName: 'ProjectA'.
	packageA := GtRlPackage withName: 'PackageA'.
	package := self packageWithName.
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: unknownNode).
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: projectA).
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: packageA).
	
	self assert: package outgoingDependencies size equals: 3.
	self assert: package outgoingPackageDependencies size equals: 1.
	self assert: package outgoingProjectDependencies size equals: 1.
	
	self assert: package requiredNodes size equals: 3.
	self assert: package requiredPackages size equals: 1.
	self assert: package requiredProjects size equals: 1.
	
	self assert: package requiredPackages first equals: packageA.
	self assert: package requiredProjects first equals: projectA.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithMixedOutgoingDependenciesHasNoIncomingDependencies [
	<gtExample>
	| package |
	package := self packageWithMixedOutgoingDependencies.
	
	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingPackageDependencies size equals: 0.
	self assert: package dependentPackages size equals: 0.
	
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithName [
	<gtExample>
	| package |
	package := GtRlPackage new
		name: 'Package-Main'.
	
	self assert: package name equals: 'Package-Main'.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependencies [
	<gtExample>
	| package packageA packageB |
	package := self packageWithName.
	packageA := GtRlPackage withName: 'PackageA'.
	packageB := GtRlPackage withName: 'PackageB'.
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: packageA).
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: packageB).
	
	self assert: package outgoingDependencies size equals: 2.
	self assert: package outgoingPackageDependencies size equals: 2.
	self assert: package requiredPackages first equals: packageA.
	self assert: package requiredPackages second equals: packageB.
	self assert: package requiredNodes size equals: 2.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependenciesHasNoIncomingDependencies [
	<gtExample>
	| package |
	package := self packageWithOutgoingPackageDependencies.
	
	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingPackageDependencies size equals: 0.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependenciesHasNoProjectDependencies [
	<gtExample>
	| package |
	package := self packageWithOutgoingPackageDependencies.
	
	self assert: package requiredProjects size equals: 0.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependencies [
	<gtExample>
	| package projectA projectB |
	package := self packageWithName.
	projectA := GtRlProject withName: 'ProjectA'.
	projectB := GtRlProject withName: 'ProjectB'.
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: projectA).
	package addOutgoingDependency: (GtRlDependency new 
		sourceNode: package;
		targetNode: projectB).
	
	self assert: package outgoingDependencies size equals: 2.
	self assert: package outgoingProjectDependencies size equals: 2.
	self assert: package requiredProjects first equals: projectA.
	self assert: package requiredProjects second equals: projectB.
	self assert: package requiredNodes size equals: 2.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoDependentPackages [
	<gtExample>
	| package  |
	package := self packageWithOutgoingProjectDependencies.
	
	self assert: package dependentPackages size equals: 0.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoIncomingDependencies [
	<gtExample>
	| package  |
	package := self packageWithOutgoingProjectDependencies.
	
	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingPackageDependencies size equals: 0.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoRequiedPackages [
	<gtExample>
	| package  |
	package := self packageWithOutgoingProjectDependencies.
	
	self assert: package requiredPackages size equals: 0.
	
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithProjectWithoutProjectLink [
	<gtExample>
	| package project |
	package := self packageWithName.
	project := GtRlProject withName: 'Container'.
	package parentProject: project.
	
	self assert: package parentProject equals: project.
	self assert: project packages isEmpty.
	self assert: project repository isNil.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithUnknownOutgoingDependency [
	<gtExample>
	| package unknownNode |
	unknownNode := GtRlUnknownNode withName: 'Unknown'.
	package := self packageWithName.
	package
		addOutgoingDependency: (GtRlDependency new 
			sourceNode: package;
			targetNode: unknownNode).
	
	self assert: package requiredNodes size equals: 1.
	self assert: package outgoingDependencies size equals: 1.
	self assert: package incomingDependencies size equals: 0.
	
	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithUnknownOutgoingDependencyHasNoProjectsOrPackages [
	<gtExample>
	| package |
	
	package := self packageWithUnknownOutgoingDependency.
	
	self assert: package requiredProjects size equals: 0.
	self assert: package requiredPackages size equals: 0.
	self assert: package dependentPackages size equals: 0.
	
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithinProjectWihoutRepository [
	<gtExample>
	| package project |
	package := self packageWithName.
	project := GtRlProject withName: 'Container'.
	project addPackage: package.
	
	self assert: package parentProject equals: project.
	self assert: project packages size equals: 1.
	self assert: project packages first equals: package.
	self assert: package repository isNil.
	
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithinProjectWithRepository [
	<gtExample>
	| package project repository |
	repository := GtRlRepositoryExamples new repositoryWithGithubUrlNoVersion.
	package := self packageWithName.
	project := GtRlProject withName: 'Container'.
	project linkWithRepository: repository.
	project addPackage: package.
	
	self assert: package parentProject equals: project.
	self assert: package repository equals: repository.
	
	^ package
]
