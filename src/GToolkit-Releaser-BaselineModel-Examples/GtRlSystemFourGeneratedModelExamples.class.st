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
	<return: #GtRlPackage>
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
	<return: #GtRlPackage>
	| package |
	package := self packageAMainNode.

	self assert: package requiredPackages size equals: 0.
	self assert: package requiredProjectReferences size equals: 0.
	self assert: package requiredNodes size equals: 0.
	self assert: package outgoingDependencies size equals: 0.

	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageAMainNode [
	<gtExample>
	<return: #GtRlPackage>
	| project package |
	^ thePackageAMainNode
		ifNil: [ project := self systemProject.
			package := project packages first.

			self assert: package name equals: 'PackageAMain'.
			self assert: package parentProject equals: project.

			thePackageAMainNode := package ]
]

{ #category : #'examples - packages' }
GtRlSystemFourGeneratedModelExamples >> packageAPart1HasBothDependencies [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageAPart1Node.

	self assert: package incomingDependencies size equals: 1.
	self assert: package outgoingDependencies size equals: 1.
	self assert: package dependentPackages size equals: 1.
	self assert: package requiredPackages size equals: 1.

	self assert: package dependentPackages first equals: self packageATestNode.
	self assert: package requiredPackages first equals: self packageAMainNode.
	^ package
]

{ #category : #'examples - packages' }
GtRlSystemFourGeneratedModelExamples >> packageAPart1HasCorrectParent [
	<gtExample>
	<return: #GtRlPackage>
	| package |
	package := self packageAPart1Node.

	self assert: package parentProject equals: self systemProject.

	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageAPart1Node [
	<gtExample>
	<return: #GtRlPackage>
	| project package |
	^ thePackageAPart1Node
		ifNil: [ project := self systemProject.
			package := project packages fourth.

			self assert: package name equals: 'PackageA-Part1'.
			self assert: package parentProject equals: project.

			thePackageAPart1Node := package ]
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> packageATestNode [
	<gtExample>
	<return: #GtRlPackage>
	| project package |
	^ thePackageTestNode
		ifNil: [ project := self systemProject.
			package := project packages fifth.

			self assert: package name equals: 'PackageA-Test'.
			self assert: package parentProject equals: project.

			thePackageTestNode := package ]
]

{ #category : #'examples - system' }
GtRlSystemFourGeneratedModelExamples >> systemHasCorrectPackages [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemProject.

	self assert: project packages size equals: 5.
	self
		assert: (project packages collect: #name) asArray
		equals: #('PackageAMain' 'PackageB' 'PackageB-Tests' 'PackageA-Part1' 'PackageA-Test').
	^ project
]

{ #category : #'examples - system' }
GtRlSystemFourGeneratedModelExamples >> systemHasNoProjectDependencoes [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemProject.

	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project projectReferences size equals: 0.
	self assert: project parentProjects size equals: 0.
	^ project
]

{ #category : #'examples - nodes' }
GtRlSystemFourGeneratedModelExamples >> systemProject [
	<gtExample>
	<return: #GtRlProject>
	| projectBuilder project repositoryName |
	^ theSystemProject
		ifNil: [ repositoryName := 'github://example/SystemFour/src'.
			projectBuilder := GtRlDependenciesModelBuilder new.
			project := projectBuilder
					buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemFourWithPackages
					withRepositoryDescription: repositoryName.

			self assert: project name equals: 'GtRlBaselineExampleSystemFourWithPackages'.

			theSystemProject := project ]
]
