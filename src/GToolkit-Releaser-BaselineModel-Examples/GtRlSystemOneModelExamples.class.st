Class {
	#name : #GtRlSystemOneModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #assertions }
GtRlSystemOneModelExamples >> assertBaseline: aBaselineClass forProject: aProject [

	self assert: aProject name equals: (aBaselineClass name withoutPrefix: 'BaselineOf').
	self assert: aProject baselineClass equals: aBaselineClass.
	self assert: aProject baselineVersion equals: aBaselineClass project version.
]

{ #category : #assertions }
GtRlSystemOneModelExamples >> assertStandaloneRepository: aRepository [
	self assert: aRepository isLeaf.
	self assert: aRepository projects isEmpty.
	self assert: aRepository childRepositories isEmpty.
	self assert: aRepository parentRepositories isEmpty. 
	
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentA [
	<gtExample>
	| project repository |
	project := GtRlProject new
		name: 'GtRlBaselineExampleComponentA';
		baselineClass: BaselineOfGtRlBaselineExampleComponentA;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentA project version.
	repository := self repositoryComponentA.
	project
		linkWithRepository: repository.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentA forProject: project.
	self assert: project repository equals: repository.
	self assert: repository projects asArray equals: { project }.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentB [
	<gtExample>
	| projectBMain projectBUtil repository |
	projectBMain := GtRlProject new
		name: 'GtRlBaselineExampleComponentBMain';
		baselineClass: BaselineOfGtRlBaselineExampleComponentBMain;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentBMain project version.
	projectBUtil := GtRlProject new
		name: 'GtRlBaselineExampleComponentBUtil';
		baselineClass: BaselineOfGtRlBaselineExampleComponentBUtil;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentBUtil project version.
	repository := self repositoryComponentB.
	projectBMain linkWithRepository: repository.
	projectBUtil linkWithRepository: repository.
	projectBMain addChildProject: projectBUtil.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentBMain forProject: projectBMain.
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentBUtil forProject: projectBUtil.
	self assert: repository projects asArray equals: { projectBMain .  projectBUtil }.
	self assert: repository childRepositories isEmpty.
	
	^ projectBMain
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentC [
	<gtExample>
	| project repository |
	project := GtRlProject new
		name: 'GtRlBaselineExampleComponentC';
		baselineClass: BaselineOfGtRlBaselineExampleComponentC;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentC project version.
	repository := self repositoryComponentC.
	project
		linkWithRepository: repository.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentC forProject: project.
	self assert: project repository equals: repository.
	self assert: repository projects asArray equals: { project }.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentD [
	<gtExample>
	| projectD projectDModuleA repository |
	projectD := GtRlProject new
		name: 'GtRlBaselineExampleComponentD';
		baselineClass: BaselineOfGtRlBaselineExampleComponentD;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentD project version.
	projectDModuleA := self projectComponentDModuleA.
	repository := self repositoryComponentD.
	projectD
		linkWithRepository: repository;
		addChildProject: projectDModuleA.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentD forProject: projectD.
	self assert: projectD repository equals: repository.
	self assert: repository projects asArray equals: { projectD }.
	self assert: repository childRepositories asArray equals: { projectDModuleA repository }.
	self assert: projectD childProjects asArray equals: { projectDModuleA }.
	
	^ projectD
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentDModuleA [
	<gtExample>
	| project repository |
	project := GtRlProject new
		name: 'GtRlBaselineExampleComponentDModuleA';
		baselineClass: BaselineOfGtRlBaselineExampleComponentDModuleA;
		baselineVersion: BaselineOfGtRlBaselineExampleComponentDModuleA project version.
	repository := self repositoryComponentDModuleA.
	project
		linkWithRepository: repository.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleComponentDModuleA forProject: project.
	self assert: project repository equals: repository.
	self assert: repository projects asArray equals: { project }.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectSystem [
	<gtExample>
	| projectSystem componentA componentB componentC componentD repository |
	projectSystem := GtRlProject new
		name: 'GtRlBaselineExampleSystemOne';
		baselineClass: BaselineOfGtRlBaselineExampleSystemOne;
		baselineVersion: BaselineOfGtRlBaselineExampleSystemOne project version.
	componentA := self projectComponentA.
	componentB := self projectComponentB.
	componentC := self projectComponentC.
	componentD := self projectComponentD.
	repository := self repositorySystem.
	projectSystem
		linkWithRepository: repository;
		addChildProjects: { componentA . componentB . componentC . componentD }.
	
	self assertBaseline: BaselineOfGtRlBaselineExampleSystemOne forProject: projectSystem.
	self 
		assert: repository childRepositories asArray 
		equals: { componentA repository . componentB repository . componentC repository . componentD repository }.
	self assert: componentA repository parentRepositories asArray equals: {repository}.
	
	^ projectSystem
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentA [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/ComponentA/src'.
	
	self assert: repository id equals: 'github://example/ComponentA/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentB [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/ComponentB/src'.
	
	self assert: repository id equals: 'github://example/ComponentB/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentC [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/ComponentC/src'.
	
	self assert: repository id equals: 'github://example/ComponentC/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentD [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/ComponentD/src'.
	
	self assert: repository id equals: 'github://example/ComponentD/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentDModuleA [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/ComponentDModuleA/src'.
	
	self assert: repository id equals: 'github://example/ComponentDModuleA/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositorySystem [
	<gtExample>
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/SystemOne/src'.
	
	self assert: repository id equals: 'github://example/SystemOne/src'.
	self assertStandaloneRepository: repository.
	
	^ repository
]
