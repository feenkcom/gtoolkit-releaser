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
	#category : 'GToolkit-Releaser'
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
GtMetrics class >> totalClassesClassSideSize [
	<gtExample>
	<noTest>
	
	^ SystemNavigation default  allClasses 
		sum: [ :aClass |
	 		aClass classSide gtSpecificSizeInMemory ].
]

{ #category : #accessing }
GtMetrics class >> totalClassesCount [
	<gtExample>
	<noTest>
	
	^ SystemNavigation default  allClasses size
]

{ #category : #accessing }
GtMetrics class >> totalClassesInstanceSideSize [
	<gtExample>
	<noTest>
	
	^ SystemNavigation default  allClasses 
		sum: [ :aClass |
	 		aClass instanceSide gtSpecificSizeInMemory ].
]

{ #category : #accessing }
GtMetrics class >> totalClassesSize [
	<gtExample>
	<noTest>
	
	^ self totalClassesClassSideSize  + self totalClassesInstanceSideSize
]

{ #category : #accessing }
GtMetrics class >> totalCodeAnalysedSize [
	<gtExample>
	<noTest>
	
	^ self totalClassesSize 
		+ self totalMethodsSize 
		+ self totalSymbolsSize 
		+ self totalPragmasCacheSize
		+ self totalCompleterCacheSize
]

{ #category : #accessing }
GtMetrics class >> totalCompleterCacheSize [
	<gtExample>
	<noTest>
	
	^ GtPharoCompletionStrategy cacheSizeInMemory 
]

{ #category : #accessing }
GtMetrics class >> totalMethodDictionaryInstancesCount [
	<gtExample>
	<noTest>
	
	^ MethodDictionary allInstances  size
]

{ #category : #accessing }
GtMetrics class >> totalMethodDictionarySize [
	<gtExample>
	<noTest>
	
	^ MethodDictionary allInstances 
		sum: [ :aMethodDictionary | aMethodDictionary gtSpecificSizeInMemory ]
]

{ #category : #accessing }
GtMetrics class >> totalMethodsCount [
	<gtExample>
	<noTest>
	
	^ SystemNavigation default  allMethods size
]

{ #category : #accessing }
GtMetrics class >> totalMethodsSize [
	<gtExample>
	<noTest>
	
	^ SystemNavigation default  allMethods 
		sum: #gtSpecificSizeInMemory
]

{ #category : #accessing }
GtMetrics class >> totalPragmasCacheSize [
	<gtExample>
	<noTest>
	^ Pragma pragmaCache gtSpecificSizeInMemory + 
		(Pragma pragmaCache sum: [ :pragmasSet | 
			pragmasSet gtSpecificSizeInMemory +  (pragmasSet sum: #sizeInMemory) ]).
]

{ #category : #accessing }
GtMetrics class >> totalSymbolsCount [
	<gtExample>
	<noTest>
	
	^ Symbol allSymbols size
]

{ #category : #accessing }
GtMetrics class >> totalSymbolsSize [
	<gtExample>
	<noTest>
	
	^ Symbol allSymbols sum: [ :aSymbol | aSymbol sizeInMemory ].
]

{ #category : #accessing }
GtMetrics class >> totalTraitsOverheadSize [
	<gtExample>
	<noTest>
	| targetTraits traitsOverheadSize |
	
	targetTraits := Smalltalk allClasses 
		select: [ :class | class isTrait ].
	targetTraits remove: TraitedClass.

	traitsOverheadSize := targetTraits  
		inject: 0
		into: [ :memorySize :targetTait | 
			memorySize 
				+ targetTait class localMethodDict gtSpecificSizeInMemory
				+ targetTait class baseLocalMethods gtSpecificSizeInMemory ].
	
	^ traitsOverheadSize 
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

{ #category : #accessing }
GtMetrics >> gtBarChartFor: aView [
	<gtView>
	| theData projectsAndSizes maxLines aBarWidthScale barChart |
	^ aView explicit
		title: 'Bar chart';
		stencil: [
			projectsAndSizes := self gtProjects collect: [:project | 
				{project . project gtRPackages sumNumbers: #linesOfCode}].
			theData := GtPlotterDataGroup new 
				values: projectsAndSizes.
			theData := theData sorted: [ :a :b | (a last) > (b last) ].
			theData := theData labelled: [ :each | each first gtDisplayString gtRemovePrefix: 'BaselineOf' ].
			theData := theData colored: [ :each | Color r: 66 g: 188 b: 238 range: 255 ].
			maxLines := theData inject: 0 intoValues: [ :anAmount :eachValue | anAmount max: eachValue last ].
			aBarWidthScale := GtPlotterLinearScale new domainFrom: 0 to: maxLines.
			GtPlotterHorizontalBarChart new
				barElement: [ :aGtPlotterContext | 
				BlElement new
					aptitude: ((BrGlamorousWithTooltipAptitude2 content: [
						BrLabel new
							text: (aGtPlotterContext originalValue second);
							aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets all: 1)) ]) hideDelay: 0; showDelay: 0) ];
				barLabelWidth: 200;
				barWidthScale: aBarWidthScale;
				barWidthData: [ :eachValue | eachValue last ];
				amountOfTicks: 4;
				with: theData ]
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
			name: 'Pharo';
			leaves: {
				GtNestedTreeItemLeaf new 
					item: 'Pharo used in GT' -> ((Color lightGray) alpha: 1);
					weight: [:x | GtMetrics default basePharoLinesOfCode - GtMetrics default pharoToReplaceLinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'Pharo not used in GT' -> ((Color lightGray) alpha: 0.5);
					weight: [ :x | GtMetrics default pharoToReplaceLinesOfCode ]. }.
		GtNestedTreeNode new 
			name: 'Glamorous Toolkit';
			leaves: {
				GtNestedTreeItemLeaf new 
					item: 'Glamorous Toolkit Core' -> ((BrGlamorousColors primaryBorderColor) alpha: 1);
					weight: [:x | GtMetrics default gtLinesOfCode - GtMetrics default smaccParsersLinesOfCode - GtMetrics default xmlSupportLinesOfCode - GtMetrics default famix3LinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'Parsers' -> ((BrGlamorousColors primaryBorderColor) alpha: 0.5);
					weight: [ :x | GtMetrics default smaccParsersLinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'XML' -> ((BrGlamorousColors primaryBorderColor) alpha: 0.5);
					weight: [ :x | GtMetrics default xmlSupportLinesOfCode].
				GtNestedTreeItemLeaf new 
					item: 'Famix' -> ((BrGlamorousColors primaryBorderColor) alpha: 0.5);
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
		addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color black); text: 'Entire image');
		addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color gray); text: GtMetrics default totalLinesOfCode asString).
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
		addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color black); text: group name);
		addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color gray); text: group weight asString).
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
			addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color black); text: leaf item key gtDisplayString);
			addChild: (BrLabel new aptitude: (BrGlamorousLabelAptitude new fontSize: 10; foreground: Color gray); text: leaf weight asString).
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
		items: [ {('GT projects' -> self gtProjects).
			('Pharo projects not used in GT' -> self pharoToReplaceProjects)} ];
		column: 'Metric' text: #key;
		column: 'Value' text: [ :each | each value size ];
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
		BaselineOfSpec.
		BaselineOfSpec2 } flatCollect: [:project | 
			project version withDeepCollect: [ :each | 
				each projects collect: #version ] as: Set ].
	self assert: projects notEmpty.
	self assert: (projects noneSatisfy: #isNil).
	^ (projects \ {BaselineOfTraits version . BaselineOfUnifiedFFI version . BaselineOfReflectivity version}) \ self gtProjects
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
