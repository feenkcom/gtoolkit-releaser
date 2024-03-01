Class {
	#name : #GtRlSystemOneModelExamples,
	#superclass : #Object,
	#instVars : [
		'projectComponentA',
		'projectComponentBUtil',
		'projectComponentC',
		'projectComponentD',
		'projectComponentDModuleA',
		'repositoryComponentA',
		'repositoryComponentB',
		'repositoryComponentC',
		'repositoryComponentD',
		'repositoryComponentDModuleA',
		'projectComponentBMain'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
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
	^ projectComponentA ifNil: [
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
	
		projectComponentA := project ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentBMain [
	<gtExample>
	^ projectComponentBMain ifNil: [ 
		| projectBMain projectBUtil projectBUtilReference repository |
		projectBMain := GtRlProject new
			name: 'GtRlBaselineExampleComponentBMain';
			baselineClass: BaselineOfGtRlBaselineExampleComponentBMain;
			baselineVersion: BaselineOfGtRlBaselineExampleComponentBMain project version.
		projectBUtil := self projectComponentBUtil.
		projectBUtilReference := GtRlProjectReference forReferencedProject: projectBUtil.
		projectBMain addProjectReference: projectBUtilReference.
		repository := self repositoryComponentB.
		projectBMain linkWithRepository: repository.
	
		self assertBaseline: BaselineOfGtRlBaselineExampleComponentBMain forProject: projectBMain.
		self assert: repository projects asArray equals: { projectBUtil . projectBMain }.
		self assert: repository childRepositories isEmpty.
		
		self assert: projectBMain childProjects asArray equals: { projectBUtil }.
		self assert: projectBMain projectReferences asArray equals: { projectBUtilReference }.
	
		projectComponentBMain := projectBMain ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentBUtil [
	<gtExample>
	^ projectComponentBUtil ifNil: [
		| project repository |
		project := GtRlProject new
			name: 'GtRlBaselineExampleComponentBUtil';
			baselineClass: BaselineOfGtRlBaselineExampleComponentBUtil;
			baselineVersion: BaselineOfGtRlBaselineExampleComponentBUtil project version.
		repository := self repositoryComponentB.
		project linkWithRepository: repository.
	
		self assertBaseline: BaselineOfGtRlBaselineExampleComponentBUtil forProject: project.
		self assert: repository projects asArray equals: { project }.
		self assert: repository childRepositories isEmpty.
	
		projectComponentBUtil := project ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentC [
	<gtExample>
	^ projectComponentC ifNil: [ | project repository |
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
	
		projectComponentC := project ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentD [
	<gtExample>
	^ projectComponentD ifNil: [
		| projectD projectDModuleA projectDModuleAReference repository |
		projectD := GtRlProject new
			name: 'GtRlBaselineExampleComponentD';
			baselineClass: BaselineOfGtRlBaselineExampleComponentD;
			baselineVersion: BaselineOfGtRlBaselineExampleComponentD project version.
		projectDModuleA := self projectComponentDModuleA.
		projectDModuleAReference := GtRlProjectReference forReferencedProject: projectDModuleA.
		repository := self repositoryComponentD.
		projectD
			linkWithRepository: repository;
			addProjectReference: projectDModuleAReference.
		
		self assertBaseline: BaselineOfGtRlBaselineExampleComponentD forProject: projectD.
		self assert: projectD repository equals: repository.
		self assert: repository projects asArray equals: { projectD }.
		self assert: repository childRepositories asArray equals: { projectDModuleA repository }.
		self assert: projectD childProjects asArray equals: { projectDModuleA }.
		self assert: projectD projectReferences asArray equals: { projectDModuleAReference }.
	
		projectComponentD := projectD ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectComponentDModuleA [
	<gtExample>
	^ projectComponentDModuleA ifNil: [ 
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
	
		projectComponentDModuleA := project ]
]

{ #category : #'examples - projects' }
GtRlSystemOneModelExamples >> projectSystem [
	<gtExample>
	| projectSystem componentA componentB componentC componentD componentAReference componentBReference componentCReference componentDReference repository |
	projectSystem := GtRlProject new
		name: 'GtRlBaselineExampleSystemOne';
		baselineClass: BaselineOfGtRlBaselineExampleSystemOne;
		baselineVersion: BaselineOfGtRlBaselineExampleSystemOne project version.
	componentA := self projectComponentA.
	componentB := self projectComponentBMain.
	componentC := self projectComponentC.
	componentD := self projectComponentD.
	componentAReference := GtRlProjectReference forReferencedProject: componentA.
	componentBReference := GtRlProjectReference forReferencedProject: componentB.
	componentCReference := GtRlProjectReference forReferencedProject: componentC.
	componentDReference := GtRlProjectReference forReferencedProject: componentD.
	repository := self repositorySystem.
	projectSystem
		linkWithRepository: repository;
		addProjectReferences: { componentAReference . componentBReference . componentCReference . componentDReference }.
	
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
	^ repositoryComponentA ifNil: [
		repositoryComponentA := GtRlRepository fromUrlString: 'github://example/ComponentA/src'.
	
		self assert: repositoryComponentA id equals: 'github://example/ComponentA/src'.
		self assertStandaloneRepository: repositoryComponentA.
	
		repositoryComponentA ]
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentB [
	<gtExample>
	^ repositoryComponentB ifNil: [ 
		repositoryComponentB := GtRlRepository fromUrlString: 'github://example/ComponentB/src'.
	
		self assert: repositoryComponentB id equals: 'github://example/ComponentB/src'.
		self assertStandaloneRepository: repositoryComponentB.
		
		repositoryComponentB ]
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentC [
	<gtExample>
	^ repositoryComponentC ifNil: [ 
		repositoryComponentC := GtRlRepository fromUrlString: 'github://example/ComponentC/src'.
	
		self assert: repositoryComponentC id equals: 'github://example/ComponentC/src'.
		self assertStandaloneRepository: repositoryComponentC.
	
		repositoryComponentC ]
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentD [
	<gtExample>
	^ repositoryComponentD ifNil: [
		repositoryComponentD := GtRlRepository fromUrlString: 'github://example/ComponentD/src'.
	
		self assert: repositoryComponentD id equals: 'github://example/ComponentD/src'.
		self assertStandaloneRepository: repositoryComponentD.
	
		repositoryComponentD ]
]

{ #category : #'examples - repositories' }
GtRlSystemOneModelExamples >> repositoryComponentDModuleA [
	<gtExample>
	^ repositoryComponentDModuleA ifNil: [ 
		repositoryComponentDModuleA := GtRlRepository fromUrlString: 'github://example/ComponentDModuleA/src'.
	
		self assert: repositoryComponentDModuleA id equals: 'github://example/ComponentDModuleA/src'.
		self assertStandaloneRepository: repositoryComponentDModuleA.
	
		repositoryComponentDModuleA ]
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

{ #category : #'examples - systemOne' }
GtRlSystemOneModelExamples >> systemOneCorrectNumberOfChildProjects [
	<gtExample>
	| project |
	project := self projectSystem. 
		
	self assert: project isLeaf not.
	self assert: project childProjects size equals: 4.
	self assert: project withAllChildProjects size equals: 7.
	self assert: project childProjects asArray equals: {
		self projectComponentA. self projectComponentBMain. self projectComponentC. self projectComponentD }.
	
	^ project
]

{ #category : #'examples - systemOne' }
GtRlSystemOneModelExamples >> systemOneCorrectNumberOfProjectReferences [
	<gtExample>
	| project |
	project := self projectSystem. 
	
	self assert: project projectReferences size equals: 4.
	self assert: project allProjectReferences size equals: 6.
	
	^ project
]
