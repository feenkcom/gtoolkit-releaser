Class {
	#name : #GtRlPackageExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - empty package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoDependencies [
	<gtExample>
	| package |
	package :=self packageWithName .
	self assert: package dependencies isEmpty.	
	^ package
]

{ #category : #'examples - empty package' }
GtRlPackageExamples >> emptyPackageShouldHaveNoProject [
	<gtExample>
	| package |
	package :=self packageWithName .
	self assert: package parentProject isNil.
	self assert: package repository isNil.
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithMixedDependencies [
	<gtExample>
	| package |
	package := self packageWithName.
	package addDependencies: {
		GtRlProject withName: 'ProjectA'.
		GtRlUnknownNode withName: 'Unknown'.
		GtRlPackage withName: 'PackageB' }.
	
	self assert: package dependencies size equals: 3.
	self assert: package dependencies first name equals: 'ProjectA'.
	self assert: package dependencies second name equals: 'Unknown'.
	self assert: package dependencies third name equals: 'PackageB'.
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithName [
	<gtExample>
	| package |
	package := GtRlPackage new
		name: 'Package-Main'.
	
	self assert: package name equals: 'Package-Main'.
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithPackageDependencies [
	<gtExample>
	| package |
	package := self packageWithName.
	package addDependencies: {
		GtRlPackage withName: 'PackageA'.
		GtRlPackage withName: 'PackageB'}.
	
	self assert: package dependencies size equals: 2.
	self assert: package dependencies first name equals: 'PackageA'.
	self assert: package dependencies second name equals: 'PackageB'.
	self assert: package parentProject isNil.
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithProjectDependencies [
	<gtExample>
	| package |
	package := self packageWithName.
	package addDependencies: {
		GtRlProject withName: 'ProjectA'.
		GtRlProject withName: 'ProjectB'}.
	
	self assert: package dependencies size equals: 2.
	self assert: package dependencies first name equals: 'ProjectA'.
	self assert: package dependencies second name equals: 'ProjectB'.
	
	^ package
]

{ #category : #examples }
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

{ #category : #examples }
GtRlPackageExamples >> packageWithUnknownDependency [
	<gtExample>
	| package |
	package := GtRlPackage new
		name: 'Package-Main';
		addDependencies: {GtRlUnknownNode withName: 'Unknown'}.
	
	self assert: package dependencies size equals: 1.
	self assert: package dependencies first name equals: 'Unknown'.
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithinProject [
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

{ #category : #examples }
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

{ #category : #examples }
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
