"
A generic printer that generates the source code of a baseline.

The main API method for generating the source code is {{gtMethod:GtRlBaselineGenerator>>generateBaselineSource}}.

It adds to the baseline the pre and post actions, together with all package and project dependencies.
The writting of the actual baseline code is done using a {{gtClass:GtRlBaselinePrinterStream}} stream.

Subclasses define the project model that provides information about dependencies.
"
Class {
	#name : #GtRlBaselineGenerator,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Generator'
}

{ #category : #accessing }
GtRlBaselineGenerator >> baselineCategory [
	^ 'baseline'
]

{ #category : #accessing }
GtRlBaselineGenerator >> baselineProject [
	self subclassResponsibility 
]

{ #category : #compiling }
GtRlBaselineGenerator >> compileBaselineMethod [
	| baselineSource compilationResult |
	baselineSource := self generateBaselineSource.
	GtPharoCodeModifier current critical: [  
		compilationResult := self baselineProject baselineClass
			compile: baselineSource
			classified: self baselineCategory ].
	compilationResult ifNil: [ self error: 'Error compiling the method' ]
]

{ #category : #api }
GtRlBaselineGenerator >> generateBaselineSource [
	^ String streamContents: [ :aRawStream |
		| baselineStream |
		baselineStream := GtRlBaselinePrinterStream new
			stream: aRawStream.
		self generateBaselineSourceOn: baselineStream ]
]

{ #category : #api }
GtRlBaselineGenerator >> generateBaselineSourceOn: aStream [
	aStream baselineWithCommonSpecOn: [  
		self generatePreAndPostActionsOn: aStream.
		self generateProjectDependenciesOn: aStream.
		(self hasProjectDependencies and: [ 
			self baselineProject  packages notEmpty ])
				ifTrue: [ aStream newLine ].
		self generatePackageDependenciesOn: aStream ]
]

{ #category : #api }
GtRlBaselineGenerator >> generatePackageDependenciesOn: aStream [
	self baselineProject packages do: [ :aPackage |
		aStream 
			packageFor: aPackage name
			withDependencies: aPackage outgoingDependencyNames ]
]

{ #category : #api }
GtRlBaselineGenerator >> generatePreAndPostActionsOn: aStream [
	self baselineProject preLoadAction ifNotNil: [ 
		aStream preLoadAction: self baselineProject preLoadAction ].
	self baselineProject postLoadAction ifNotNil: [
		aStream postLoadAction: self baselineProject postLoadAction ].
]

{ #category : #api }
GtRlBaselineGenerator >> generateProjectDependenciesOn: aStream [
	self subclassResponsibility 
]

{ #category : #accessing }
GtRlBaselineGenerator >> gtViewGeneratedBaselineFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Generated baseline';
		priority: 101;
		text: [ self generateBaselineSource ]
]

{ #category : #testing }
GtRlBaselineGenerator >> hasProjectDependencies [
	self subclassResponsibility 
]

{ #category : #accessing }
GtRlBaselineGenerator >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: self baselineProject name;
		nextPutAll: ')'
]
