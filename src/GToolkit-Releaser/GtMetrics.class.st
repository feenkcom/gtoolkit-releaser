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

{ #category : #accessing }
GtMetrics >> gtMapFor: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		stencil: [ 
		| value container all allBarsContainer |
value := GtNestedTreeNode new
	name: 'Entire distribution';
	nodes: {
		GtNestedTreeNode new 
			name: 'Default Pharo';
			leaves: {
				GtNestedTreeItemLeaf new 
					item: 'Pharo used in GT' -> ((Color fromHexString: '5eb3ea') alpha: 1);
					weight: [:x | GtMetrics default basePharoLinesOfCode - GtMetrics default pharoToReplaceLinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'Pharo not used in GT' -> ((Color fromHexString: '5eb3ea') alpha: 0.5);
					weight: [ :x | GtMetrics default pharoToReplaceLinesOfCode ]. }.
		GtNestedTreeNode new 
			name: 'Glamorous Toolkit';
			leaves: {
				GtNestedTreeItemLeaf new 
					item: 'Rest of GT' -> ((Color fromHexString: '20d8fd') alpha: 1);
					weight: [:x | GtMetrics default gtLinesOfCode - GtMetrics default smaccParsersLinesOfCode - GtMetrics default xmlSupportLinesOfCode - GtMetrics default famix3LinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'Parsers' -> ((Color fromHexString: '20d8fd') alpha: 0.5);
					weight: [ :x | GtMetrics default smaccParsersLinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'XML' -> ((Color fromHexString: '20d8fd') alpha: 0.5);
					weight: [ :x | GtMetrics default xmlSupportLinesOfCode].
				GtNestedTreeItemLeaf new 
					item: 'Famix' -> ((Color fromHexString: '20d8fd') alpha: 0.5);
					weight: [ :x | GtMetrics default famix3LinesOfCode]. }}.

container := BlElement new
	constraintsDo: [:c | c vertical fitContent. c horizontal fitContent];
	layout: BlLinearLayout vertical alignCenter.
allBarsContainer := BlElement new 
		constraintsDo: [:c | c vertical fitContent. c horizontal fitContent];
		layout: BlLinearLayout horizontal.
container 
	addChild: allBarsContainer;
	addChild: (BlElement new 
			margin: (BlInsets top: 20);
			constraintsDo: [:c | c vertical exact: 1. c horizontal matchParent];
			background: (Color black alpha: 0.2));
		addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color black); text: 'Entire image');
		addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color gray); text: GtMetrics default totalLinesOfCode asString).
value nodes do: [ :group | 
	| groupElement barsContainer | 
	groupElement := BlElement new 
		constraintsDo: [:c | c vertical fitContent. c horizontal fitContent];
		layout: BlLinearLayout vertical alignCenter;
		margin: (BlInsets left: 2 right: 2).
	barsContainer := BlElement new 
		constraintsDo: [:c | c vertical fitContent. c horizontal fitContent];
		layout: BlLinearLayout horizontal.
	allBarsContainer addChild: groupElement.
	groupElement 
		addChild: barsContainer;
		addChild: (BlElement new 
			margin: (BlInsets top: 20);
			constraintsDo: [:c | c vertical exact: 1. c horizontal matchParent];
			background: (Color black alpha: 0.2));
		addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color black); text: group name);
		addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color gray); text: group weight asString).
	group leaves do: [:leaf | 
		| leafContainer leafBar |
		leafBar := BlElement new 
			constraintsDo: [:c | c vertical exact: 50. c horizontal exact: leaf weight / 1200];
			background: (leaf item value).
		leafContainer := BlElement new 
			constraintsDo: [:c | c vertical fitContent. c horizontal fitContent];
			layout: BlLinearLayout vertical alignCenter;
			margin: (BlInsets left: 2 right: 2).
		leafContainer
			addChild: leafBar; 
			addChild: (BlElement new 
					margin: (BlInsets top: 20);
					constraintsDo: [:c | c vertical exact: 1. c horizontal matchParent];
					background: (Color black alpha: 0.2));
			addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color black); text: leaf item key gtDisplayString);
			addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10; foreground: Color gray); text: leaf weight asString).
		barsContainer addChild: leafContainer.
		] ].
(container asScalableElement maxScale: 1.2) margin: (BlInsets all: 20)
	]
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
				'Total code in image' -> self totalLinesOfCode.
				'Glamorous Toolkit code' -> self gtLinesOfCode.
				'Pharo code' -> self basePharoLinesOfCode.
				'Pharo code not used in Glamorous Toolkit' -> self pharoToReplaceLinesOfCode.
				'Parsers for other langauges' -> self smaccParsersLinesOfCode.
				'Code analysis model' -> self famix3LinesOfCode.
				'XML support' -> self xmlSupportLinesOfCode
			} ];
		column: 'Item' format: #key;
		column: 'Lines of code' format: #value
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

{ #category : #accessing }
GtMetrics >> totalLinesOfCode [
	^ totalLinesOfCode ifNil: [ totalLinesOfCode := (Smalltalk allClassesAndTraits flatCollect: #localMethods) sumNumbers: #linesOfCode ]
]

{ #category : #accessing }
GtMetrics >> xmlSupportLinesOfCode [
	^ xmlSupportLinesOfCode ifNil: [ xmlSupportLinesOfCode := (BaselineOfGToolkit4XMLSupport version withDeepCollect: [ :each | each projects collect: #version ])
		sum: [:each | each gtRPackages sum: #linesOfCode ]. ]
]
