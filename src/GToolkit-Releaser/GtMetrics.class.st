Class {
	#name : #GtMetrics,
	#superclass : #Object,
	#instVars : [
		'basePharoLinesOfCode',
		'gtLinesOfCode',
		'pharoToReplaceLinesOfCode',
		'smaccParsersLinesOfCode',
		'famix3LinesOfCode',
		'xmlSupportLinesOfCode',
		'totalLinesOfCode'
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

{ #category : #accessing }
GtMetrics >> basePharoLinesOfCode [
	^ basePharoLinesOfCode ifNil: [ basePharoLinesOfCode := self totalLinesOfCode - self gtLinesOfCode ]
]

{ #category : #accessing }
GtMetrics >> famix3LinesOfCode [
	^ famix3LinesOfCode ifNil: [ famix3LinesOfCode := (BaselineOfFamix3SmalltalkImporter version 
	withDeepCollect: [ :each | each projects collect: #version ])
		sum: [:each | each gtRPackages sum: #linesOfCode ] ]
]

{ #category : #accessing }
GtMetrics >> gtLinesOfCode [
	^ gtLinesOfCode ifNil: [ gtLinesOfCode := self gtMethods sumNumbers: [ :each | each linesOfCode ] ]
]

{ #category : #accessing }
GtMetrics >> gtMethods [
	^ self methodsInProjects: self gtProjects
]

{ #category : #'gt-extensions' }
GtMetrics >> gtMetricsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Metrics';
		items: [ {('Total code in image' -> self totalLinesOfCode).
			('Glamorous Toolkit code' -> self gtLinesOfCode).
			('Pharo code' -> self basePharoLinesOfCode).
			('Pharo code not used in Glamorous Toolkit'
				-> self pharoToReplaceLinesOfCode).
			('Parsers for other langauges' -> self smaccParsersLinesOfCode).
			('Code analysis model' -> self famix3LinesOfCode).
			('XML support' -> self xmlSupportLinesOfCode)} ];
		column: 'Item' text: #key;
		column: 'Lines of code' text: #value
]

{ #category : #accessing }
GtMetrics >> gtProjects [
	| projects |
	projects := {BaselineOfGToolkit} flatCollect: [:project | 
			project version withDeepCollect: [ :each | 
				each projects collect: #version ] as: Set ].
	self assert: projects notEmpty.
	self assert: (projects noneSatisfy: #isNil).
	^ projects
]

{ #category : #'gt-extensions' }
GtMetrics >> gtProjectsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Projects';
		priority: 1;
		items: [ {('GT projects' -> self gtProjects).
			('Pharo projects not used in GT' -> self pharoToReplaceProjects)} ];
		column: 'Metric' text: #key;
		column: 'Value' text: [ :each | each value size ];
		send: #value
]

{ #category : #accessing }
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

{ #category : #accessing }
GtMetrics >> pharoToReplaceLinesOfCode [
	^ pharoToReplaceLinesOfCode ifNil: [ pharoToReplaceLinesOfCode := self pharoToReplaceMethods sumNumbers: [ :each | each linesOfCode ] ]
]

{ #category : #accessing }
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
		BaselineOfQA . 
		BaselineOfOSWindow.
		BaselineOfSpec2 } flatCollect: [:project | 
			project version withDeepCollect: [ :each | 
				each projects collect: #version ] as: Set ].
	self assert: projects notEmpty.
	self assert: (projects noneSatisfy: #isNil).
	^ (projects \ {BaselineOfTraits version . BaselineOfUnifiedFFI version . BaselineOfReflectivity version}) \ self gtProjects
]

{ #category : #accessing }
GtMetrics >> smaccParserPackages [
	^ ((BaselineOfSmaCC project version
		withDeepCollect: [ :each | each projects collect: #version ]
		as: Set) flatCollect: #gtRPackages)
		select: [ :each | 
			({'SmaCC_Grammar_Parser'.
				'SmaCC_Debugging_Support'.
				'SmaCC_Rewrite'.
				'SmaCC_Rewrite_Engine'.
				'SmaCC_Rewrite_Engine_Tests'} includes: each name) not
				and: [ each classes anySatisfy: [ :c | c inheritsFrom: SmaCCScanner ] ] ]
]

{ #category : #accessing }
GtMetrics >> smaccParsersLinesOfCode [
	^ smaccParsersLinesOfCode ifNil: [ smaccParsersLinesOfCode := self smaccParserPackages sum: #linesOfCode]
]

{ #category : #accessing }
GtMetrics >> totalLinesOfCode [
	^ totalLinesOfCode ifNil: [ totalLinesOfCode := (Smalltalk allClassesAndTraits flatCollect: #localMethods) sumNumbers: #linesOfCode ]
]

{ #category : #accessing }
GtMetrics >> xmlSupportLinesOfCode [
	^ xmlSupportLinesOfCode ifNil: [ xmlSupportLinesOfCode := (BaselineOfGToolkit4XMLSupport version withDeepCollect: [ :each | each projects collect: #version ])
		sum: [:each | each gtRPackages sum: #linesOfCode ]. ]
]
