Extension { #name : #GtMetrics }

{ #category : #'*GToolkit-Releaser-UI' }
GtMetrics >> gtBarChartFor: aView [
	<gtView>
	| theData projectsAndSizes maxLines aBarWidthScale |
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

{ #category : #'*GToolkit-Releaser-UI' }
GtMetrics >> gtMapFor: aView [
	<gtView>
	^ aView explicit
		title: 'Map';
		stencil: [ 
		| value container allBarsContainer |
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
					item: 'Glamorous Toolkit Core' -> ((BrGlamorousColors primaryBorderColor));
					weight: [:x | GtMetrics default gtLinesOfCode - GtMetrics default smaccParsersLinesOfCode - GtMetrics default xmlSupportLinesOfCode - GtMetrics default famix3LinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'Parsers' -> ((BrGlamorousColors primaryBorderColor));
					weight: [ :x | GtMetrics default smaccParsersLinesOfCode ].
				GtNestedTreeItemLeaf new 
					item: 'XML' -> ((BrGlamorousColors primaryBorderColor));
					weight: [ :x | GtMetrics default xmlSupportLinesOfCode].
				GtNestedTreeItemLeaf new 
					item: 'Famix' -> ((BrGlamorousColors primaryBorderColor));
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
