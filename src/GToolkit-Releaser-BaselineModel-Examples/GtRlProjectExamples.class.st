Class {
	#name : #GtRlProjectExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithBaselineClass [
	<gtExample>
	| project |
	project := self projectWithName.
	project baselineClass: BaselineOfGtRlBaselineExampleSystemOne.
	
	self assert: project baselineClass equals: BaselineOfGtRlBaselineExampleSystemOne.
	self assert: project childProjects isEmpty.
	self assert: project parentProjects isEmpty.
	self assert: project baselineVersion isNil.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithBaselineVersion [
	<gtExample>
	| project |
	project := self projectWithName.
	project baselineVersion: BaselineOfGtRlBaselineExampleSystemOne project version.
	
	self assert: project baselineVersion versionNumber equals: (MetacelloVersionNumber fromString: 'baseline').
	self assert: project childProjects isEmpty.
	self assert: project parentProjects isEmpty.
	self assert: project baselineClass isNil.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithChildren [
	<gtExample>
	| project childA childB referenceA referenceB |
	project := self projectWithName.
	childA := GtRlProject new 
		name: 'ChildA'.
	childB := GtRlProject new 
		name: 'ChildB'.
	referenceA := GtRlProjectReference new
		referencedProject: childA.
	referenceB := GtRlProjectReference new
		referencedProject: childB.
	
	project 
		addProjectReference: referenceA;
		addProjectReference: referenceB.
	
	self assert: referenceA parentProject equals: project.
	self assert: referenceB parentProject equals: project.
	self assert: project projectReferences asArray equals: {referenceA . referenceB}.
	
	self assert: project childProjects asArray equals: {childA . childB}.
	self assert: project isLeaf not.
	self assert: childA isLeaf.
	self assert: childB isLeaf.
	self assert: childA parentProjects asArray equals: {project}.
	self assert: childB parentProjects asArray equals: {project}.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithName [
	<gtExample>
	| project |
	project := GtRlProject new
		name: 'ExampleProject'.
	
	self assert: project name equals: 'ExampleProject'.
	self assert: project childProjects isEmpty.
	self assert: project parentProjects isEmpty.
	self assert: project baselineClass isNil.
	self assert: project baselineVersion isNil.
	self assert: project preLoadAction isNil.
	self assert: project postLoadAction isNil.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithPackages [
	<gtExample>
	| project packageA packageB |
	project := self projectWithName.
	packageA := GtRlPackage new
		name: 'PackageA'.
	packageB := GtRlPackage new
		name: 'PackageB'.
	project 
		addPackage: packageA;
		addPackage: packageB.
	
	self assert: project packages asArray equals: { packageA . packageB }.
	self assert: packageA parentProject equals: project.
	self assert: packageB parentProject equals: project.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithPostLoadAction [
	<gtExample>
	| project |
	project := self projectWithName.
	project baselineClass: BaselineOfGtRlBaselineExampleStandaloneWithActions.
	project postLoadAction: #postloadAction:.
	
	self assert: project postLoadAction equals: #postloadAction:.
	self assert: (BaselineOfGtRlBaselineExampleStandaloneWithActions includesSelector: #postloadAction:).
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithPreLoadAction [
	<gtExample>
	| project |
	project := self projectWithName.
	project baselineClass: BaselineOfGtRlBaselineExampleStandaloneWithActions.
	project preLoadAction: #preloadAction:.
	
	self assert: project preLoadAction equals: #preloadAction:.
	self assert: (BaselineOfGtRlBaselineExampleStandaloneWithActions includesSelector: #preloadAction:).
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithRepository [
	<gtExample>
	| project repository |
	repository := GtRlRepositoryExamples new repositoryWithGithubUrlNoVersion.
	project := self projectWithName.
	project linkWithRepository: repository.
	
	self assert: project repository equals: repository.
	self assert: repository projects asArray equals: { project }.
	self assert: project isLeaf.
	self assert: repository isLeaf.
	
	^ project
]

{ #category : #'examples - structure' }
GtRlProjectExamples >> projectWithStructureWithinDistinctRepos [
	<gtExample>
	| project childA childB repositoryOne repositoryTwo repositoryThree |
	project := self projectWithChildren.
	repositoryOne := GtRlRepositoryExamples new repositoryWithGithubUrlNoVersion.
	repositoryTwo := GtRlRepository fromUrlString: 'github://example/gtoolkit-two/src'.
	repositoryThree := GtRlRepository fromUrlString: 'github://example/gtoolkit-three/src'.
	childA := project childProjects first.
	childB := project childProjects second.
	
	project linkWithRepository: repositoryOne.
	childA linkWithRepository: repositoryTwo.
	childB linkWithRepository: repositoryThree.
	
	self assert: repositoryOne projects asArray equals: {project}.
	self assert: repositoryTwo projects asArray equals: {childA}.
	self assert: repositoryThree projects asArray equals: {childB}.
	self assert: repositoryOne childRepositories asArray equals: {repositoryTwo. repositoryThree}.
	
	^ project
]

{ #category : #'examples - structure' }
GtRlProjectExamples >> projectWithStructureWithinOneRepo [
	<gtExample>
	| project childA childB repository |
	project := self projectWithChildren.
	repository := GtRlRepositoryExamples new repositoryWithGithubUrlNoVersion.
	childA := project childProjects first.
	childB := project childProjects second.
	
	project linkWithRepository: repository.
	childA linkWithRepository: repository.
	childB linkWithRepository: repository.
	
	self assert: repository projects asArray equals: {project . childA . childB}.
	
	^ project
]

{ #category : #'examples - basic' }
GtRlProjectExamples >> projectWithTwoParents [
	<gtExample>
	| project parentA parentB parentReferenceA parentReferenceB |
	project := self projectWithName.
	parentA := GtRlProject new 
		name: 'ParentA'.
	parentB := GtRlProject new 
		name: 'ParentB'.
	parentReferenceA := GtRlProjectReference new
		referencedProject: project.
	parentReferenceB := GtRlProjectReference new
		referencedProject: project.
	
	parentA addProjectReference: parentReferenceA.
	parentB addProjectReference: parentReferenceB.
	
	self assert: parentReferenceA parentProject equals: parentA.
	self assert: parentReferenceB parentProject equals: parentB.
	self assert: parentA projectReferences asArray equals: {parentReferenceA}.
	self assert: parentB projectReferences asArray equals: {parentReferenceB}.
	
	self assert: project parentProjects asArray equals: {parentA . parentB}.
	self assert: project isLeaf.
	self assert: parentA isLeaf not.
	self assert: parentB isLeaf not.
	self assert: parentA childProjects asArray equals: {project}.
	self assert: parentB childProjects asArray equals: {project}.
	
	^ project
]

{ #category : #'examples - generated' }
GtRlProjectExamples >> systemOneProject [
	<gtExample>
	| projectBuilder project repositoryName |
	repositoryName := 'github://example/SystemOne/src'.
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: repositoryName. 
	
	self assert: project projectReferences size equals: 4.
	self assert: project childProjects size equals: 4.
	self assert: project withAllChildProjects size equals: 7.
	self assert: project allProjectReferences size equals: 6.
	self assert: project parentProjects size equals: 0.
	self assert: project repository urlString equals: repositoryName.
	self assert: project withAllRepositories size equals: 6.
	
	^ project
]
