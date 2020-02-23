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
		painting: [:m |
m nodes 
	stencil: [ :each |
		| element container |
		container := BrVerticalPane new vFitContent; hFitContent.
		element := BlElement new
			geometry: BlEllipse new;
			border: (BlBorder paint: Color black width: 2);
			size: 20@20;
			when: BlClickEvent do: [:e | e target phlow spawnObject: each];
			look: (BrWithTooltipLook2 new
		preferredExtent: 200@200;
		showDelay: 100 milliSeconds;
		hideDelay: 100 milliSeconds;
		stencil: [ 
			BlElement new
				look: (BrTooltipLook2 new  content: ((GtMethodCoder forExample: each) expanded: true) asElement)]).
		((self containedExamples examples collect: #example) includes: each) ifTrue: [element background: (BrGlamorousColors primaryBorderColor)].
		container addChild: element.
		container ];
	with: ((self containedExamples examples collect: #example) withDeepCollect: #directDependencies) asSet.
m edges 
	fromNearestTightCircle;
	toNearestTightCircle;
	stencil: [ :each | BlParabollaArcElement new curvatureFraction: 0.1;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build))];
	connectToAll: #directDependencies.
m layout horizontalDominanceTree nodeDistance: 10 ]
]

{ #category : #ui }
GtRlExamplesExplorer >> gtViewExamplesFor: aView [
	<gtView>
	^ self containedExamples gtExamplesFor: aView
]
