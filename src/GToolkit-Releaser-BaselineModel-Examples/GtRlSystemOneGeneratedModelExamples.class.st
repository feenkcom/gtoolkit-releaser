Class {
	#name : #GtRlSystemOneGeneratedModelExamples,
	#superclass : #Object,
	#instVars : [
		'theSystemOneProject',
		'theComponentAProject',
		'theComponentBProject',
		'theComponentCProject',
		'theComponentDProject'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentA/src'.
	project := self componentAProject. 
		
	self assert: project repository urlString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasNoChildren [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project projectReferences size equals: 0.
	self assert: project allProjectReferences size equals: 0.
	self assert: project withAllChildProjects size equals: 1.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasNoPackages [
	<gtExample>
	| project |
	project := self componentAProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentAProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentAProject [
	<gtExample>
	| project component |
	^ theComponentAProject ifNil: [ 
		project := self systemOneProject. 
		component := project childProjects first.
	
		self assert: component name equals: 'GtRlBaselineExampleComponentA'.
	
		theComponentAProject := component ]
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentB/src'.
	project := self componentBProject. 
		
	self assert: project repository urlString equals: repositoryName.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasNoPackages [
	<gtExample>
	| project |
	project := self componentBProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasOneChild [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 1.
	self assert: project withAllChildProjects size equals: 2.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasOneProjectReference [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project projectReferences size equals: 1.
	self assert: project allProjectReferences size equals: 1.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasOneRepositoryForAllChildren [
	<gtExample>
	|  project |
	project := self componentBProject. 
	
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentBProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentBProject [
	<gtExample>
	| project component |
	^ theComponentBProject ifNil: [ 
		project := self systemOneProject. 
		component := project childProjects second.
	
		self assert: component name equals: 'GtRlBaselineExampleComponentBMain'.
	
		theComponentBProject := component ]
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/ComponentC/src'.
	project := self componentCProject. 
		
	self assert: project repository urlString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasNoChildren [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project isLeaf.
	self assert: project childProjects size equals: 0.
	self assert: project withAllChildProjects size equals: 1.
	self assert: project projectReferences size equals: 0.
	self assert: project allProjectReferences size equals: 0.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasNoPackages [
	<gtExample>
	| project |
	project := self componentCProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentCProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentCProject [
	<gtExample>
	| project component |
	^ theComponentCProject ifNil: [
		project := self systemOneProject. 
		component := project childProjects third.
	
		self assert: component name equals: 'GtRlBaselineExampleComponentC'.
	
		theComponentCProject := component ]
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasDistinctRepositoryForChild [
	<gtExample>
	|  project |
	project := self componentDProject. 
	
	self assert: project withAllRepositories size equals: 2.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasNoPackages [
	<gtExample>
	| project |
	project := self componentDProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasOneChild [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 1.
	self assert: project withAllChildProjects size equals: 2.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasOneProjectReference [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 1.
	self assert: project withAllChildProjects size equals: 2.
	self assert: project projectReferences size equals: 1.
	self assert: project allProjectReferences size equals: 1.
	
	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasSystemOneAsParent [
	<gtExample>
	| project |
	project := self componentDProject. 
		
	self assert: project parentProjects size equals: 1.
	self assert: project parentProjects first name equals: 'GtRlBaselineExampleSystemOne'.
	
	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentDProject [
	<gtExample>
	| project component |
	^ theComponentDProject ifNil: [
		project := self systemOneProject. 
		component := project childProjects fourth.
	
		self assert: component name equals: 'GtRlBaselineExampleComponentD'.
	
		theComponentDProject := component ]
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfChildProjects [
	<gtExample>
	| project |
	project := self systemOneProject. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 4.
	self assert: project withAllChildProjects size equals: 7.
	self assert: project childProjects asArray equals: {
		self componentAProject. self componentBProject. self componentCProject. self componentDProject }.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfParentProjects [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project parentProjects size equals: 0.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfProjectReferences [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project projectReferences size equals: 4.
	self assert: project allProjectReferences size equals: 6.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectRepositoryName [
	<gtExample>
	| repositoryName project |
	repositoryName := 'github://example/SystemOne/src'.
	project := self systemOneProject. 
	
	self assert: project repository urlString equals: repositoryName.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectTotalNumberOfRepositories [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project withAllRepositories size equals: 6.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneHasNoPackages [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project packages size equals: 0.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneHasNoPreAndPostLoadActions [
	<gtExample>
	| project |
	project := self systemOneProject. 
	
	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.
	
	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> systemOneProject [
	<gtExample>
	| projectBuilder project repositoryName |
	^ theSystemOneProject ifNil: [ 
		repositoryName := 'github://example/SystemOne/src'.
		projectBuilder := GtRlDependenciesModelBuilder new.
		project := projectBuilder 
			buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
			withRepositoryDescription: repositoryName. 
	
		self assert: project name equals: 'GtRlBaselineExampleSystemOne'.
	
		theSystemOneProject := project ]
]
