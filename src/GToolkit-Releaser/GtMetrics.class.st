Class {
	#name : #GtMetrics,
	#superclass : #Object,
	#instVars : [
		'basePharoLinesOfCode',
		'gtLinesOfCode',
		'pharoToReplaceLinesOfCode',
		'smaccParsersLinesOfCode',
		'famix3LinesOfCode',
		'xmlSupportLinesOfCode'
	],
	#classVars : [
		'default'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtMetrics class >> default [
	<gtExample>
	^ default ifNil: [ default := GtMetrics new ]
]

{ #category : #accessing }
GtMetrics class >> reset [
	default := nil
]

{ #category : #'as yet unclassified' }
GtMetrics >> basePharoLinesOfCode [
	^ basePharoLinesOfCode ifNil: [ basePharoLinesOfCode := self totalLinesOfCode - self gtLinesOfCode ]
]

{ #category : #accessing }
GtMetrics >> famix3LinesOfCode [
	^ famix3LinesOfCode ifNil: [ famix3LinesOfCode := (BaselineOfFamix3SmalltalkImporter version 
	withDeepCollect: [ :each | each projects collect: #version ])
		sum: [:each | each gtRPackages sum: #linesOfCode ] ]
]

{ #category : #'as yet unclassified' }
GtMetrics >> gtLinesOfCode [
	^ gtLinesOfCode ifNil: [ gtLinesOfCode := self gtMethods sumNumbers: [ :each | each linesOfCode ] ]
]

{ #category : #'as yet unclassified' }
GtMetrics >> gtMethods [
	^ self methodsInProjects: self gtProjects
]

{ #category : #accessing }
GtMetrics >> gtMetricsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Metrics';
		items: [ 
			{
				'GT lines of code' -> self gtLinesOfCode.
				'Pharo lines of code' -> self basePharoLinesOfCode.
				'Pharo lines not used in GT' -> self pharoToReplaceLinesOfCode.
			} ];
		column: 'Metric' format: #key;
		column: 'Value' format: #value
]

{ #category : #'as yet unclassified' }
GtMetrics >> gtProjects [
	| projects |
	projects := {BaselineOfGToolkit} flatCollect: [:project | 
			project version withDeepCollect: [ :each | 
				each projects collect: #version ] as: Set ].
	self assert: projects notEmpty.
	self assert: (projects noneSatisfy: #isNil).
	^ projects
]

{ #category : #accessing }
GtMetrics >> gtProjectsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Projects';
		priority: 1;
		items: [ 
			{
				'GT projects' -> self gtProjects.
				'Pharo projects not used in GT' -> self pharoToReplaceProjects.
			} ];
		column: 'Metric' format: #key;
		column: 'Value' format: [ :each | each value size ];
		send: #value
]

{ #category : #'as yet unclassified' }
GtMetrics >> methodsInProjects: aCollection [
	| mPackages packages |
	mPackages := aCollection flatCollect: [:each | each packages ].
	packages := mPackages 
		collect: [:each | RPackageOrganizer default packageNamed: each name asSymbol ifAbsent: [nil]]
		thenSelect: #notNil.
	self assert: packages notEmpty.
	^ (Smalltalk allClassesAndTraits flatCollect: #localMethods) select: [:each | 
		packages includes: each package ]
]

{ #category : #'as yet unclassified' }
GtMetrics >> pharoToReplaceLinesOfCode [
	^ pharoToReplaceLinesOfCode ifNil: [ pharoToReplaceLinesOfCode := self pharoToReplaceMethods sumNumbers: [ :each | each linesOfCode ] ]
]

{ #category : #'as yet unclassified' }
GtMetrics >> pharoToReplaceMethods [
	^ self methodsInProjects: self pharoToReplaceProjects
]

{ #category : #accessing }
GtMetrics >> pharoToReplaceProjects [
	| projects |
	projects := {BaselineOfBasicTools . 
		BaselineOfShout . 
		BaselineOfGeneralHelp . 
		BaselineOfCalypso . 
		BaselineOfPharoGlamour . 
		BaselineOfPharoGT . 
		BaselineOfQA . 
		BaselineOfOSWindow. 
		BaselineOfBlueInk} flatCollect: [:project | 
			project version withDeepCollect: [ :each | 
				each projects collect: #version ] as: Set ].
	self assert: projects notEmpty.
	self assert: (projects noneSatisfy: #isNil).
	^ projects \ {BaselineOfTraits version . BaselineOfUnifiedFFI version . BaselineOfReflectivity version}
]

{ #category : #accessing }
GtMetrics >> smaccParserPackages [
	^ (BaselineOfSmaCC version gtRPackages select: [:each | 
	({'SnaCC_Grammar_Parser' . 'SmaCC_Debugging_Support' . 'SmaCC_Rewrite' . 'SmaCC_Rewrite_Engine' . 'SmaCC_Rewrite_Engine_Tests'} includes: each name) not and: [
		each classes anySatisfy: [:c | c inheritsFrom: SmaCCScanner]]])
]

{ #category : #accessing }
GtMetrics >> smaccParsersLinesOfCode [
	^ smaccParsersLinesOfCode ifNil: [ smaccParsersLinesOfCode := self smaccParserPackages sum: #linesOfCode]
]

{ #category : #'as yet unclassified' }
GtMetrics >> totalLinesOfCode [
	^ (Smalltalk allClassesAndTraits flatCollect: #localMethods) sumNumbers: #linesOfCode
]

{ #category : #accessing }
GtMetrics >> xmlSupportLinesOfCode [
	^ xmlSupportLinesOfCode ifNil: [ xmlSupportLinesOfCode := (BaselineOfGToolkit4XMLSupport version withDeepCollect: [ :each | each projects collect: #version ])
		sum: [:each | each gtRPackages sum: #linesOfCode ]. ]
]
