Class {
	#name : #GtRlSystemFiveGeneratedModelExamples,
	#superclass : #Object,
	#instVars : [
		'theSystemProject',
		'thePackageANode',
		'thePackageBNode',
		'theReferenceComponentANode',
		'theReferenceComponentBNode',
		'thePackageCNode'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> componentAReferenceAHasProjectDependencies [
	<gtExample>
	| projectReference |
	projectReference := self componentAReferenceNode.
	
	self assert: projectReference incomingDependencies size equals: 1.
	self assert: projectReference incomingDependenciesFromPackages size equals: 1.
	self assert: projectReference dependentPackages size equals: 1.
	
	self assert: projectReference dependentPackages first equals: self packageANode.
	^ projectReference
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> componentAReferenceNode [
	<gtExample>
	| project projectReference |
	^ theReferenceComponentANode ifNil: [
		project := self systemProject.
		projectReference := project projectReferences first. 
		
		self assert: projectReference name equals: 'GtRlBaselineExampleSystemFiveComponentA'.
		self assert: projectReference parentProject equals: project.
		
		theReferenceComponentANode := projectReference ]
]

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> componentBReferenceAHasProjectDependencies [
	<gtExample>
	| projectReference |
	projectReference := self componentBReferenceNode.
	
	self assert: projectReference incomingDependencies size equals: 2.
	self assert: projectReference incomingDependenciesFromPackages size equals: 2.
	self assert: projectReference dependentPackages size equals: 2.
	
	self assert: projectReference dependentPackages first equals: self packageBNode.
	self assert: projectReference dependentPackages second equals: self packageCNode.
	
	^ projectReference
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> componentBReferenceNode [
	<gtExample>
	| project projectReference |
	^ theReferenceComponentBNode ifNil: [
		project := self systemProject.
		projectReference := project projectReferences second. 
		
		self assert: projectReference name equals: 'GtRlBaselineExampleSystemFiveComponentB'.
		self assert: projectReference parentProject equals: project.
		
		theReferenceComponentBNode := projectReference ]
]

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> packageAHasProjectDependencies [
	<gtExample>
	| package |
	package := self packageANode.
	
	self assert: package incomingDependencies size equals: 1.
	self assert: package outgoingDependencies size equals: 1.
	self assert: package dependentPackages size equals: 1.
	self assert: package requiredPackages size equals: 0.
	self assert: package requiredProjectReferences size equals: 1.
	
	self assert: package requiredProjectReferences first equals: self componentAReferenceNode.
	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> packageANode [
	<gtExample>
	| project package |
	^ thePackageANode ifNil: [
		project := self systemProject.
		package := project packages first. 
	
		self assert: package name equals: 'PackageA'.
		self assert: package parentProject equals: project.
	
		thePackageANode := package ]
]

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> packageBHasProjectDependencies [
	<gtExample>
	| package |
	package := self packageBNode.
	
	self assert: package incomingDependencies size equals: 0.
	self assert: package outgoingDependencies size equals: 2.
	self assert: package requiredPackages size equals: 1.
	self assert: package requiredProjectReferences size equals: 1.
	
	self assert: package requiredPackages first equals: self packageANode.
	self assert: package requiredProjectReferences first equals: self componentBReferenceNode.
	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> packageBNode [
	<gtExample>
	| project package |
	^ thePackageBNode ifNil: [
		project := self systemProject.
		package := project packages second. 
	
		self assert: package name equals: 'PackageB'.
		self assert: package parentProject equals: project.
	
		thePackageBNode := package ]
]

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> packageCHasProjectDependencies [
	<gtExample>
	| package |
	package := self packageCNode.
	
	self assert: package incomingDependencies size equals: 0.
	self assert: package outgoingDependencies size equals: 1.
	self assert: package dependentPackages size equals: 0.
	self assert: package requiredPackages size equals: 0.
	self assert: package requiredProjectReferences size equals: 1.
	
	self assert: package requiredProjectReferences first equals: self componentBReferenceNode.
	^ package
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> packageCNode [
	<gtExample>
	| project package |
	^ thePackageCNode ifNil: [
		project := self systemProject.
		package := project packages third. 
	
		self assert: package name equals: 'PackageC'.
		self assert: package parentProject equals: project.
	
		thePackageCNode := package ]
]

{ #category : #'examples - nodes' }
GtRlSystemFiveGeneratedModelExamples >> systemProject [
	<gtExample>
	| projectBuilder project repositoryName |
	^ theSystemProject ifNil: [ 
		repositoryName := 'github://example/SystemFive/src'.
		projectBuilder := GtRlDependenciesModelBuilder new.
		project := projectBuilder 
			buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemFive
			withRepositoryDescription: repositoryName. 
		
		self assert: project name equals: 'GtRlBaselineExampleSystemFive'.
		
		theSystemProject := project ]
]

{ #category : #examples }
GtRlSystemFiveGeneratedModelExamples >> systemProjectHasTwoRootPackagess [
	<gtExample>
	| system rootPackages |
	system := self systemProject.
	rootPackages := system rootPackages.
	
	self assert: rootPackages size equals: 2.
	self assert: rootPackages asArray equals: {
		self packageBNode. self packageCNode}.
	^ system
]
