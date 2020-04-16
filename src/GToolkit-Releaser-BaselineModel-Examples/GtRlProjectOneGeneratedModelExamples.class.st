Class {
	#name : #GtRlProjectOneGeneratedModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - component A' }
GtRlProjectOneGeneratedModelExamples >> componentAHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentA/src'.
	project := self componentAProject. 
		
	self assert: project repository urlString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlProjectOneGeneratedModelExamples >> componentAHasNoChildren [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project withAllChildProjects size equals: 1.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlProjectOneGeneratedModelExamples >> componentAHasNoPackages [
	<gtExample>
	| project |
	project := self componentAProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlProjectOneGeneratedModelExamples >> componentAHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlProjectOneGeneratedModelExamples >> componentAHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlProjectOneGeneratedModelExamples >> componentAProject [
	<gtExample>
	| project component |
	project := self systemOneProject. 
	component := project childProjects first.
	
	self assert: component name equals: 'GtRlBaselineExampleComponentA'.
	
	^ component
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentB/src'.
	project := self componentBProject. 
		
	self assert: project repository urlString equals: repositoryName.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasNoPackages [
	<gtExample>
	| project |
	project := self componentBProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasOneChild [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 1.
	self assert: project withAllChildProjects size equals: 2.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasOneRepositoryForAllChildren [
	<gtExample>
	|  project |
	project := self componentBProject. 
	
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlProjectOneGeneratedModelExamples >> componentBHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlProjectOneGeneratedModelExamples >> componentBProject [
	<gtExample>
	| project component |
	project := self systemOneProject. 
	component := project childProjects second.
	
	self assert: component name equals: 'GtRlBaselineExampleComponentBMain'.
	
	^ component
]

{ #category : #'examples - component C' }
GtRlProjectOneGeneratedModelExamples >> componentCHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentC/src'.
	project := self componentCProject. 
		
	self assert: project repository urlString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlProjectOneGeneratedModelExamples >> componentCHasNoChildren [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project withAllChildProjects size equals: 1.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlProjectOneGeneratedModelExamples >> componentCHasNoPackages [
	<gtExample>
	| project |
	project := self componentCProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlProjectOneGeneratedModelExamples >> componentCHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlProjectOneGeneratedModelExamples >> componentCHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlProjectOneGeneratedModelExamples >> componentCProject [
	<gtExample>
	| project component |
	project := self systemOneProject. 
	component := project childProjects third.
	
	self assert: component name equals: 'GtRlBaselineExampleComponentC'.
	
	^ component
]

{ #category : #'examples - component D' }
GtRlProjectOneGeneratedModelExamples >> componentDHasDistinctRepositoryForChild [
	<gtExample>
	|  project |
	project := self componentDProject. 
	
	self assert: project withAllRepositories size equals: 2.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlProjectOneGeneratedModelExamples >> componentDHasNoPackages [
	<gtExample>
	| project |
	project := self componentDProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlProjectOneGeneratedModelExamples >> componentDHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlProjectOneGeneratedModelExamples >> componentDHasOneChild [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 1.
	self assert: project withAllChildProjects size equals: 2.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlProjectOneGeneratedModelExamples >> componentDHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlProjectOneGeneratedModelExamples >> componentDProject [
	<gtExample>
	| project component |
	project := self systemOneProject. 
	component := project childProjects fourth.
	
	self assert: component name equals: 'GtRlBaselineExampleComponentD'.
	
	^ component
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneCorrectNumberOfChildProjects [
	<gtExample>
	| project |
	project := self systemOneProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 4.
	self assert: project withAllChildProjects size equals: 7.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneCorrectNumberOfParentProjects [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project parentProjects size equals: 0.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/SystemOne/src'.
	project := self systemOneProject. 
	
	self assert: project repository urlString equals: repositoryName.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneCorrectTotalNumberOfRepositories [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project withAllRepositories size equals: 6.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneHasNoPackages [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlProjectOneGeneratedModelExamples >> systemOneHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #examples }
GtRlProjectOneGeneratedModelExamples >> systemOneProject [
	<gtExample>
	| projectBuilder project repositoryName |
	repositoryName := 'github://example/SystemOne/src'.
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: repositoryName. 
	
	self assert: project name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]
