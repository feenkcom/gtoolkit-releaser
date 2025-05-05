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
	<return: #GtRlProject>
	| repositoryName project |
	repositoryName := 'github://example/ComponentA/src'.
	project := self componentAProject.

	self assert: project repository loadSpecificationString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.

	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasNoChildren [
	<gtExample>
	<return: #GtRlProject>
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
	<return: #GtRlProject>
	| project |
	project := self componentAProject.

	self assert: project packages size equals: 0.

	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasNoPreAndPostLoadActions [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentAProject.

	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.

	^ project
]

{ #category : #'examples - component A' }
GtRlSystemOneGeneratedModelExamples >> componentAHasSystemOneAsParent [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentAProject.

	self assert: project parentProjects size equals: 1.
	self
		assert: project parentProjects first name
		equals: 'GtRlBaselineExampleSystemOne'.

	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentAProject [
	<gtExample>
	<return: #GtRlProject>
	| project component |
	^ theComponentAProject
		ifNil: [ project := self systemOneProject.
			component := project childProjects first.

			self assert: component name equals: 'GtRlBaselineExampleComponentA'.

			theComponentAProject := component ]
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasCorrectRepositoryName [
	<gtExample>
	<return: #GtRlProject>
	| repositoryName project |
	repositoryName := 'github://example/ComponentB/src'.
	project := self componentBProject.

	self assert: project repository loadSpecificationString equals: repositoryName.

	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasNoPackages [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentBProject.

	self assert: project packages size equals: 0.

	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasNoPreAndPostLoadActions [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentBProject.

	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.

	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasOneChild [
	<gtExample>
	<return: #GtRlProject>
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
	<return: #GtRlProject>
	| project |
	project := self componentBProject.

	self assert: project projectReferences size equals: 1.
	self assert: project allProjectReferences size equals: 1.

	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasOneRepositoryForAllChildren [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentBProject.

	self assert: project withAllRepositories size equals: 1.

	^ project
]

{ #category : #'examples - component B' }
GtRlSystemOneGeneratedModelExamples >> componentBHasSystemOneAsParent [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentBProject.

	self assert: project parentProjects size equals: 1.
	self
		assert: project parentProjects first name
		equals: 'GtRlBaselineExampleSystemOne'.

	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentBProject [
	<gtExample>
	<return: #GtRlProject>
	| project component |
	^ theComponentBProject
		ifNil: [ project := self systemOneProject.
			component := project childProjects second.

			self assert: component name equals: 'GtRlBaselineExampleComponentBMain'.

			theComponentBProject := component ]
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasCorrectRepositoryName [
	<gtExample>
	<return: #GtRlProject>
	| repositoryName project |
	repositoryName := 'github://example/ComponentC/src'.
	project := self componentCProject.

	self assert: project repository loadSpecificationString equals: repositoryName.
	self assert: project withAllRepositories size equals: 1.

	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasNoChildren [
	<gtExample>
	<return: #GtRlProject>
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
	<return: #GtRlProject>
	| project |
	project := self componentCProject.

	self assert: project packages size equals: 0.

	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasNoPreAndPostLoadActions [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentCProject.

	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.

	^ project
]

{ #category : #'examples - component C' }
GtRlSystemOneGeneratedModelExamples >> componentCHasSystemOneAsParent [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentCProject.

	self assert: project parentProjects size equals: 1.
	self
		assert: project parentProjects first name
		equals: 'GtRlBaselineExampleSystemOne'.

	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentCProject [
	<gtExample>
	<return: #GtRlProject>
	| project component |
	^ theComponentCProject
		ifNil: [ project := self systemOneProject.
			component := project childProjects third.

			self assert: component name equals: 'GtRlBaselineExampleComponentC'.

			theComponentCProject := component ]
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasDistinctRepositoryForChild [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentDProject.

	self assert: project withAllRepositories size equals: 2.

	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasNoPackages [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentDProject.

	self assert: project packages size equals: 0.

	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasNoPreAndPostLoadActions [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self componentDProject.

	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.

	^ project
]

{ #category : #'examples - component D' }
GtRlSystemOneGeneratedModelExamples >> componentDHasOneChild [
	<gtExample>
	<return: #GtRlProject>
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
	<return: #GtRlProject>
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
	<return: #GtRlProject>
	| project |
	project := self componentDProject.

	self assert: project parentProjects size equals: 1.
	self
		assert: project parentProjects first name
		equals: 'GtRlBaselineExampleSystemOne'.

	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> componentDProject [
	<gtExample>
	<return: #GtRlProject>
	| project component |
	^ theComponentDProject
		ifNil: [ project := self systemOneProject.
			component := project childProjects fourth.

			self assert: component name equals: 'GtRlBaselineExampleComponentD'.

			theComponentDProject := component ]
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfChildProjects [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project isLeaf not.
	self assert: project childProjects size equals: 4.
	self assert: project withAllChildProjects size equals: 7.
	self
		assert: project childProjects asArray
		equals: {self componentAProject.
				self componentBProject.
				self componentCProject.
				self componentDProject}.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfParentProjects [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project parentProjects size equals: 0.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectNumberOfProjectReferences [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project projectReferences size equals: 4.
	self assert: project allProjectReferences size equals: 6.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectRepositoryName [
	<gtExample>
	<return: #GtRlProject>
	| repositoryName project |
	repositoryName := 'github://example/SystemOne/src'.
	project := self systemOneProject.

	self assert: project repository loadSpecificationString equals: repositoryName.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneCorrectTotalNumberOfRepositories [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project withAllRepositories size equals: 6.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneHasNoPackages [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project packages size equals: 0.

	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneGeneratedModelExamples >> systemOneHasNoPreAndPostLoadActions [
	<gtExample>
	<return: #GtRlProject>
	| project |
	project := self systemOneProject.

	self assert: project preLoadAction equals: nil.
	self assert: project postLoadAction equals: nil.

	^ project
]

{ #category : #examples }
GtRlSystemOneGeneratedModelExamples >> systemOneProject [
	<gtExample>
	<return: #GtRlProject>
	| projectBuilder project repositoryName |
	^ theSystemOneProject
		ifNil: [ repositoryName := 'github://example/SystemOne/src'.
			projectBuilder := GtRlDependenciesModelBuilder new.
			project := projectBuilder
					buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
					withRepositoryDescription: repositoryName.

			self assert: project name equals: 'GtRlBaselineExampleSystemOne'.

			theSystemOneProject := project ]
]
