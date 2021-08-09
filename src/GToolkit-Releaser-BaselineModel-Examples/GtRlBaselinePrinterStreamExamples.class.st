Class {
	#name : 'GtRlBaselinePrinterStreamExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> baselineWithCommonSpecExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer baselineWithCommonSpecOn: [ ].
	
	self 
		assert: writer contents 
		equals: 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
	]'.

	^ writer
]

{ #category : 'examples - composition' }
GtRlBaselinePrinterStreamExamples >> baselineWithContentExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer baselineWithCommonSpecOn: [ 
		writer preLoadAction: #methodSelectorA:.
		writer postLoadAction: #methodSelectorB:.
		writer 
			projectDependencyFor: 'Example-Project' 
			withLoadSpec: 'github://example/gtoolkit/src'.
		writer 
			packageFor: 'PackageA'
			withDependencies: #().
		writer 
			packageFor: 'PackageB'
			withDependencies: #('PackageA') ].
	
	self 
		assert: writer contents 
		equals: 'baseline: spec
	<baseline>
	spec for: #''common'' do: [
		spec preLoadDoIt: #''methodSelectorA:''.
		spec postLoadDoIt: #''methodSelectorB:''.
		spec
			baseline: ''Example-Project'' with: [
				spec repository: ''github://example/gtoolkit/src'' ].
		spec package: ''PackageA''.
		spec package: ''PackageB'' with: [
			spec requires: #(''PackageA'') ].
	]'.

	^ writer
]

{ #category : 'accessing' }
GtRlBaselinePrinterStreamExamples >> basicWriterWithStream [
	^ GtRlBaselinePrinterStream new
		stream: String new writeStream.
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> commonSpecExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer commonSpecDo: [ ].
	
	self 
		assert: writer contents 
		equals: 'spec for: #''common'' do: [
]'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> methodHeaderExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer methodHeader.
	
	self 
		assert: writer contents 
		equals: 'baseline: spec
	<baseline>
'.
	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> packageWithDependenciesExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer packageLineFor: 'Test-Package' withDependencies: #('Another-Package' 'Baseline-Example').
	
	self 
		assert: writer contents 
		equals: 'spec package: ''Test-Package'' with: [
	spec requires: #(''Another-Package'' ''Baseline-Example'') ].'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> packageWithNoDependenciesExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer packageLineFor: 'Test-Package' withDependencies: #().
	
	self 
		assert: writer contents 
		equals: 'spec package: ''Test-Package''.'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> postLoadActionExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer postLoadAction: #methodSelector:.
	
	self 
		assert: writer contents 
		equals: '
spec postLoadDoIt: #''methodSelector:''.'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> postLoadActionLineExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer postLoadActionLine: #methodSelector:.
	
	self 
		assert: writer contents 
		equals: 'spec postLoadDoIt: #''methodSelector:''.'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> preLoadActionExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer preLoadAction: #methodSelector:.
	
	self 
		assert: writer contents 
		equals: '
spec preLoadDoIt: #''methodSelector:''.'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> preLoadActionLineExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer preLoadActionLine: #methodSelector:.
	
	self 
		assert: writer contents 
		equals: 'spec preLoadDoIt: #''methodSelector:''.'.

	^ writer
]

{ #category : 'examples - basic api' }
GtRlBaselinePrinterStreamExamples >> projectDependencyExample [
	<gtExample>
	| writer |
	writer := self basicWriterWithStream.
	writer 
		projectLineDependencyFor: 'Example-Project' 
		withLoadSpec: 'github://example/gtoolkit/src'.
	
	self 
		assert: writer contents 
		equals: 'spec
	baseline: ''Example-Project'' with: [
		spec repository: ''github://example/gtoolkit/src'' ].'.

	^ writer
]
