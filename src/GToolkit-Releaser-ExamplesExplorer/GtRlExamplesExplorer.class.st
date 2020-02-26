Class {
	#name : #GtRlExamplesExplorer,
	#superclass : #Object,
	#instVars : [
		'cachedExamples',
		'cachedTestCases'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #accessing }
GtRlExamplesExplorer >> containedExamples [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedExamplesCount [
	^ self containedExamples size
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedTestCases [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedTestCasesCount [
	^ self containedTestCases size
]

{ #category : #accessing }
GtRlExamplesExplorer >> gtClassesFor: aView [ 
	<gtView>
	^ self containedExamples gtClassesFor: aView
]

{ #category : #accessing }
GtRlExamplesExplorer >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian 
		title: 'Graph';
		painting: [:m | | local all grouped |
local := self containedExamples examples collect: #example.
all := local withDeepCollect: #directDependencies as: Set.
grouped := all groupedBy: [:each | each method methodClass ].
m nodes 
	stencil: [:assoc | 
		| pane default |
		pane := BlElement new
			constraintsDo: [:c | 
				c horizontal fitContent.
				c vertical fitContent ];
			layout: BlLinearLayout vertical alignCenter;
			background: Color white;
			look: BrShadowLook;
			margin: (BlInsets all: 10);
			padding: (BlInsets top: 0 left: 10 bottom: 10 right: 10).
		default := BlElement new
			constraintsDo: [:c | 
				c horizontal fitContent.
				c vertical fitContent ].
		default graph beChildrenContainer: #default.
		pane addChild: (BrLabel new text: assoc key name; look: (BrGlamorousLabelLook new foreground: Color gray); margin: (BlInsets bottom: 10)).
		pane addChild: default.
		pane ];
	with: grouped associations;
	forEach: [:assoc | 
m nodes 
	stencil: [ :each |
		| element |
		element := BlElement new
			geometry: BlEllipse new;
			constraintsDo: [:c | c horizontal fitContent. c vertical fitContent];
			border: (BlBorder paint: Color black width: 2);
			size: 20@20;
			when: BlClickEvent do: [:e | e target phlow spawnObject: each];
			look: (BrGlamorousWithTooltipLook2 new 
				contentStencil: [ 
				| container |
				container := BrVerticalPane new fitContent addChild: ((GtMethodCoder forExample: each) expanded: true) asElement.
				container when: GtPhlowObjectToSpawn do: [:e | 
					element fireEvent: (GtPhlowObjectToSpawn new object: e object; sourceElement: e target)]];
				preferredExtent: 200@200;
				showDelay: 100 milliSeconds;
				hideDelay: 100 milliSeconds ).
		(local includes: each) ifTrue: [element background: (BrGlamorousColors primaryBorderColor)].
		element ];
	with: assoc value. 
	m layout horizontalDominanceTree nodeDistance: 2; treesDistance: 4; levelDistance: 10.].
m edges 
	fromNearestTightCircle;
	toNearestTightCircle;
	stencil: [ :each | BlParabollaArcElement new curvatureFraction: 0.1;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build))];
	connect: all toAll: #directDependencies.
m layout rectanglePack.
m ]
]

{ #category : #ui }
GtRlExamplesExplorer >> gtViewExamplesFor: aView [
	<gtView>
	^ self containedExamples gtExamplesFor: aView
]
