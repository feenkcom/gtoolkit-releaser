Class {
	#name : 'GtRlProjectBaselinePrinterExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithChildProject [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec
			baseline: ''ChildProject'' with: [
				spec repository: ''github://example/gtoolkit/src'' ].
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPackageWithPackageDependenciesCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec package: ''PackageA''.
		spec package: ''PackageB'' with: [ 
			spec requires: #(''PackageA'') ]. 
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPackagesCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec package: ''PackageA''.
		spec package: ''PackageB''.
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPostLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec postLoadDoIt: #''postloadAction:''.
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPreAndPostLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec preLoadDoIt: #''preloadAction:''.
		spec postLoadDoIt: #''postloadAction:''.
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> baselineWithPreLoadCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec preLoadDoIt: #''preloadAction:''.
	]'
]

{ #category : 'accessing - code' }
GtRlProjectBaselinePrinterExamples >> emptyBaselineCode [
	^ 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
	]'
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printEmptyProject [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithName.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self emptyBaselineCode.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithChildProject [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithChildProjectWithRepository.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithChildProject.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPackageWithPackageDependency [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPackageWithPackageDependency.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPackageWithPackageDependenciesCode.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPackages [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPackages.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPackagesCode.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPostLoadAction [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPostLoadAction.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPostLoadCode.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPreAndPostLoadActions [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPreAndPostLoadActions.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPreAndPostLoadCode.
	
	^ printer
]

{ #category : 'printing' }
GtRlProjectBaselinePrinterExamples >> printProjectWithPreLoadAction [
	<gtExample>
	| project printer |
	project := GtRlProjectExamples new projectWithPreLoadAction.
	printer := GtRlProjectBaselinePrinter forProject: project.
	
	self 
		assert: printer generateBaselineSource 
		equals: self baselineWithPreLoadCode.
	
	^ printer
]
