Class {
	#name : #GtRlProjectBaselinePrinterExamples,
	#superclass : #Object,
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithChildProject [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''ChildProject'' with: [
				spec repository: ''github://example/gtoolkit/src'' ].
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPackageWithPackageDependenciesCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec package: ''PackageA''.
		spec package: ''PackageB'' with: [
			spec requires: #(''PackageA'') ].
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPackagesCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec package: ''PackageA''.
		spec package: ''PackageB''.
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPostLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec postLoadDoIt: #''postloadAction:''.
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPreAndPostLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec preLoadDoIt: #''preloadAction:''.
		spec postLoadDoIt: #''postloadAction:''.
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPreLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec preLoadDoIt: #''preloadAction:''.
	]'
]

{ #category : #'accessing - code' }
GtRlProjectBaselinePrinterExamples >> emptyBaselineCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
	]'
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printEmptyProject [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithName.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self emptyBaselineCode.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithChildProject [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithChildProjectWithRepository.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithChildProject.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPackageWithPackageDependency [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPackageWithPackageDependency.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPackageWithPackageDependenciesCode.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPackages [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPackages.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPackagesCode.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPostLoadAction [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPostLoadAction.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPostLoadCode.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPreAndPostLoadActions [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPreAndPostLoadActions.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPreAndPostLoadCode.
	
	^ printer
]

{ #category : #'examples - printing basic projects' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPreLoadAction [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPreLoadAction.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPreLoadCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printStandaloneProjectWithActions [
	<gtExample>
	| projectBuilder project printer |
	
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleStandaloneWithActions
		withRepositoryDescription: 'github://example/SystemFour/src'. 
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleStandaloneWithActions >>#baseline:) sourceCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printSystemFiveProject [
	<gtExample>
	| project printer |
	project := GtRlSystemFiveGeneratedModelExamples new systemProject.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleSystemFive >>#baseline:) sourceCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printSystemFourProject [
	<gtExample>
	| project printer |
	project := GtRlSystemFourGeneratedModelExamples new systemProject.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleSystemFourWithPackages >>#baseline:) sourceCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printSystemOneManualProject [
	<gtExample>
	| project printer |
	project := GtRlSystemOneModelExamples new projectSystem.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleSystemOne >>#baseline:) sourceCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printSystemOneProject [
	<gtExample>
	| project printer |
	project := GtRlSystemOneGeneratedModelExamples new systemOneProject.
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleSystemOne >>#baseline:) sourceCode.
	
	^ printer
]

{ #category : #'examples - printing projects' }
GtRlProjectBaselinePrinterExamples >> printSystemTwoProject [
	<gtExample>
	| projectBuilder project printer |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemTwo
		withRepositoryDescription: 'github://example/SystemTwo/src'. 
	printer := GtRlProjectBaselineGenerator forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: (BaselineOfGtRlBaselineExampleSystemTwo >>#baseline:) sourceCode.
	
	^ printer
]
