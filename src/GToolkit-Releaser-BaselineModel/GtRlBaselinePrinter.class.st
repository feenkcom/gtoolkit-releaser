"
A generic printer that generates the source code of a baseline.

The main API method for generating the source code is {{gtMethod:GtRlBaselinePrinter>>generateBaselineSource}}.

It adds to the baseline the pre and post actions, together with all package and project dependencies.
The writting of the actual baseline code is done using a {{gtClass:GtRlBaselinePrinterStream}} stream.

Subclasses define the project model that provides information about dependencies.
"
Class {
	#name : 'GtRlBaselinePrinter',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-BaselineModel-Printer'
}

{ #category : 'accessing' }
GtRlBaselinePrinter >> baselineProject [
	self subclassResponsibility 
]

{ #category : 'api' }
GtRlBaselinePrinter >> generateBaselineSource [
	^ String streamContents: [ :aRawStream |
		| baselineStream |
		baselineStream := GtRlBaselinePrinterStream new
			stream: aRawStream.
		self generateBaselineSourceOn: baselineStream ]
]

{ #category : 'api' }
GtRlBaselinePrinter >> generateBaselineSourceOn: aStream [
	aStream baselineWithCommonSpecOn: [  
		self generatePreAndPostActionsOn: aStream.
		self generateProjectDependenciesOn: aStream.
		(self hasProjectDependencies and: [ 
			self baselineProject  packages notEmpty ])
				ifTrue: [ aStream newLine ].
		self generatePackageDependenciesOn: aStream ]
]

{ #category : 'api' }
GtRlBaselinePrinter >> generatePackageDependenciesOn: aStream [
	self baselineProject packages do: [ :aPackage |
		aStream 
			packageFor: aPackage name
			withDependencies: aPackage outgoingDependencyNames ]
]

{ #category : 'api' }
GtRlBaselinePrinter >> generatePreAndPostActionsOn: aStream [
	self baselineProject preLoadAction ifNotNil: [ 
		aStream preLoadAction: self baselineProject preLoadAction ].
	self baselineProject postLoadAction ifNotNil: [
		aStream postLoadAction: self baselineProject postLoadAction ].
]

{ #category : 'api' }
GtRlBaselinePrinter >> generateProjectDependenciesOn: aStream [
	self subclassResponsibility 
]

{ #category : 'accessing' }
GtRlBaselinePrinter >> gtViewGeneratedBaselineFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Generated Baseline';
		priority: 101;
		text: [ self generateBaselineSource ]
]

{ #category : 'testing' }
GtRlBaselinePrinter >> hasProjectDependencies [
	self subclassResponsibility 
]
