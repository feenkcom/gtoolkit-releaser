Class {
	#name : #GtRlPackageExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithName.
	self assert: package outgoingDependencies isEmpty.
	self assert: package incomingDependencies isEmpty.
	self assert: package incomingDependenciesFromPackages isEmpty.
	self assert: package outgoingDependenciesToPackages isEmpty.
	self assert: package outgoingDependenciesToProjects isEmpty.
	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoPackagedAndProjects [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithName.
	self assert: package requiredPackages isEmpty.
	self assert: package requiredProjectReferences isEmpty.
	self assert: package dependentPackages isEmpty.

	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoProject [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithName.
	self assert: package parentProject isNil.
	self assert: package repository isNil.
	^ package
]

{ #category : #'examples - incoming' }
GtRlPackageExamples >> packageWithIncomingPackageDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package packageA packageB |
	package := self packageWithName.
	packageA := GtRlPackage withName: 'PackageA'.
	packageB := GtRlPackage withName: 'PackageB'.
	package
		addIncomingDependency: (GtRlPackageDependency new
				sourceNode: packageA;
				targetNode: package).
	package
		addIncomingDependency: (GtRlPackageDependency new
				sourceNode: packageB;
				targetNode: package).

	self assert: package incomingDependencies size equals: 2.
	self assert: package incomingDependenciesFromPackages size equals: 2.
	self assert: package dependentPackages first equals: packageA.
	self assert: package dependentPackages second equals: packageB.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithMixedOutgoingDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package projectA projectReferenceA packageA |
	projectA := GtRlProject withName: 'ProjectA'.
	projectReferenceA := GtRlProjectReference forReferencedProject: projectA.
	packageA := GtRlPackage withName: 'PackageA'.
	package := self packageWithName.
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: projectReferenceA).
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: packageA).

	self assert: package outgoingDependencies size equals: 2.
	self assert: package outgoingDependenciesToPackages size equals: 1.
	self assert: package outgoingDependenciesToProjects size equals: 1.

	self assert: package requiredNodes size equals: 2.
	self assert: package requiredPackages size equals: 1.
	self assert: package requiredProjectReferences size equals: 1.
	self assert: package requiredProjects size equals: 1.

	self assert: package requiredPackages first equals: packageA.
	self assert: package requiredProjectReferences first equals: projectReferenceA.
	self assert: package requiredProjects first equals: projectA.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithMixedOutgoingDependenciesHasNoIncomingDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithMixedOutgoingDependencies.

	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingDependenciesFromPackages size equals: 0.
	self assert: package dependentPackages size equals: 0.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithMixedOutgoingUknownDependency [
	<gtExample>
	<return: #GtRlPackage>
	| package unknownNode |
	unknownNode := GtRlUnknownNode withName: 'Unknown'.

	package := self packageWithName.
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: unknownNode).

	self assert: package outgoingDependencies size equals: 1.
	self assert: package outgoingDependenciesToPackages size equals: 0.
	self assert: package outgoingDependenciesToProjects size equals: 0.

	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithName [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := GtRlPackage new name: 'Package-Main'.

	self assert: package name equals: 'Package-Main'.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package packageA packageB |
	package := self packageWithName.
	packageA := GtRlPackage withName: 'PackageA'.
	packageB := GtRlPackage withName: 'PackageB'.
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: packageA).
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: packageB).

	self assert: package outgoingDependencies size equals: 2.
	self assert: package outgoingDependenciesToPackages size equals: 2.
	self assert: package requiredProjectReferences size equals: 0.
	self assert: package requiredPackages first equals: packageA.
	self assert: package requiredPackages second equals: packageB.
	self assert: package requiredNodes size equals: 2.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependenciesHasNoIncomingDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithOutgoingPackageDependencies.

	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingDependenciesFromPackages size equals: 0.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingPackageDependenciesHasNoProjectDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithOutgoingPackageDependencies.

	self assert: package requiredProjectReferences size equals: 0.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package projectA projectB projectReferenceA projectReferenceB |
	package := self packageWithName.
	projectA := GtRlProject withName: 'ProjectA'.
	projectB := GtRlProject withName: 'ProjectB'.
	projectReferenceA := GtRlProjectReference forReferencedProject: projectA.
	projectReferenceB := GtRlProjectReference forReferencedProject: projectB.
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: projectReferenceA).
	package
		addOutgoingDependency: (GtRlPackageDependency new
				sourceNode: package;
				targetNode: projectReferenceB).

	self assert: package outgoingDependencies size equals: 2.
	self assert: package outgoingDependenciesToProjects size equals: 2.
	self assert: package requiredProjects size equals: 2.
	self assert: package requiredProjectReferences size equals: 2.
	self assert: package requiredProjectReferences first equals: projectReferenceA.
	self assert: package requiredProjectReferences second equals: projectReferenceB.
	self assert: package requiredProjects first equals: projectA.
	self assert: package requiredProjects second equals: projectB.
	self assert: package requiredNodes size equals: 2.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoDependentPackages [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithOutgoingProjectDependencies.

	self assert: package dependentPackages size equals: 0.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoIncomingDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithOutgoingProjectDependencies.

	self assert: package incomingDependencies size equals: 0.
	self assert: package incomingDependenciesFromPackages size equals: 0.

	^ package
]

{ #category : #'examples - outgoing' }
GtRlPackageExamples >> packageWithOutgoingProjectDependenciesHasNoRequiedPackages [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageWithOutgoingProjectDependencies.

	self assert: package requiredPackages size equals: 0.

	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithProjectWithoutProjectLink [
	<gtExample>
	<return: #GtRlPackage>
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
	<return: #GtRlPackage>
	| package unknownNode |
	unknownNode := GtRlUnknownNode withName: 'Unknown'.
	package := self packageWithName.
	package
		addOutgoingDependency: (GtRlPackageDependency new
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
	<return: #GtRlPackage>
	| package |
	package := self packageWithUnknownOutgoingDependency.

	self assert: package requiredProjectReferences size equals: 0.
	self assert: package requiredPackages size equals: 0.
	self assert: package dependentPackages size equals: 0.

	^ package
]

{ #category : #'examples - standalone package' }
GtRlPackageExamples >> packageWithinProjectWihoutRepository [
	<gtExample>
	<return: #GtRlPackage>
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
	<return: #GtRlPackage>
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
