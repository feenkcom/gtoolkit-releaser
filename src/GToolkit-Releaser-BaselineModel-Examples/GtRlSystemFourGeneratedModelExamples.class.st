Class {
	#name : #GtRlSystemFourGeneratedModelExamples,
	#superclass : #Object,
	#instVars : [
		'theSystemProject',
		'thePackageAMainNode',
		'thePackageAPart1Node',
		'thePackageTestNode'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - packages' }
GtRlSystemFourGeneratedModelExamples >> packageAMainHasDependentPackages [
	<gtExample>
	| package |
	package := self packageAMainNode. 
	
	self assert: package incomingDependencies size equals: 2.
	self assert: package dependentPackages size equals: 2.
	self assert: package dependentPackages first equals: self packageAPart1Node.
	self assert: package dependentPackages second equals: self packageATestNode.
	
	^ package
]

{ #category : #'examples - packages' }
GtRlSystemFourGeneratedModelExamples >> packageAMainHasNoRequiredDependencies [
	<gtExample>
	| package |
	package := self packageAMainNode. 
	
	self assert: package requiredPackages size equals: 0.
	self assert: package requiredProjects size equals: 0.
	self assert: package requiredNodes size equals: 0.
	self assert: package outgoingDependencies size equals: 0.
	
	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageAMainNode [
	<gtExample>
	| project package |
	^ thePackageAMainNode ifNil: [
		project := self systemProject.
		package := project packages first. 
	
		self assert: package name equals: 'PackageAMain'.
		self assert: package parentProject equals: project.
	
		thePackageAMainNode := package ]
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageAPart1Node [
	<gtExample>
	| project package |
	^ thePackageAPart1Node ifNil: [
		project := self systemProject.
		package := project packages fourth. 
	
		self assert: package name equals: 'PackageA-Part1'.
		self assert: package parentProject equals: project.
	
		thePackageAPart1Node := package ]
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageATestNode [
	<gtExample>
	| project package |
	^ thePackageTestNode ifNil: [
		project := self systemProject.
		package := project packages fifth. 
	
		self assert: package name equals: 'PackageA-Test'.
		self assert: package parentProject equals: project.
	
		thePackageTestNode := package ]
]

{ #category : #'examples - system' }
GtRlSystemFourGeneratedModelExamples >> systemHasCorrectPackages [
	<gtExample>
	| project |
	project := self systemProject. 
	
	self assert: project packages size equals: 5.
	self 
		assert: (project packages collect: #name) asArray
		equals: #(
			'PackageAMain' 
			'PackageB' 
			'PackageB-Tests' 
			'PackageA-Part1' 
			'PackageA-Test' ).
	^ project
]

{ #category : #'examples - system' }
GtRlSystemFourGeneratedModelExamples >> systemHasNoProjectDependencoes [
	<gtExample>
	| project |
	project := self systemProject. 
	
	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project parentProjects size equals: 0.
	^ project
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> systemProject [
	<gtExample>
	| projectBuilder project repositoryName |
	^ theSystemProject ifNil: [
		repositoryName := 'github://example/SystemFour/src'.
		projectBuilder := GtRlDependenciesModelBuilder new.
		project := projectBuilder 
			buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemFourWithPackages
			withRepositoryDescription: repositoryName. 
	
		self assert: project name equals: 'GtRlBaselineExampleSystemFourWithPackages'.
		
		theSystemProject := project ]
]
