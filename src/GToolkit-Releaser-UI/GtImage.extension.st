Extension { #name : #GtImage }

{ #category : #'*GToolkit-Releaser-UI' }
GtImage >> gtExensionsFor: aView [
	<gtView>
	| inspectorPragmas spotterPragmas coderAddOnsPragmas coderContextMenuPragmas advicePragmas actionPragmas lepiterSnippets |
	^ aView columnedList
		title: 'Extensions';
		priority: 20;
		items: [ 
			inspectorPragmas := GtInspector extensionsPragma gtPragmas.
			spotterPragmas := GtSpotter extensionsPragma gtPragmas.
			coderAddOnsPragmas := GtCoderModel astExtensionsPragma gtPragmas.
			coderContextMenuPragmas := GtCoderModel contextMenuAddOnsPragma gtPragmas.
			actionPragmas := #gtAction gtPragmas.
			advicePragmas := #gtAdvice gtPragmas.
			lepiterSnippets := LeSnippet allSubclasses select: [:each | each class includesSelector: #leJsonV4Name ].
			{
				{'Inspector extensions' . inspectorPragmas . inspectorPragmas size}.
				{'Object actions' . actionPragmas . actionPragmas size}.
				{'Search extensions' . spotterPragmas . spotterPragmas size}.
				{'Coder AST AddOns' . coderAddOnsPragmas . coderAddOnsPragmas size}.
				{'Coder Menu AddOns' . coderContextMenuPragmas . coderContextMenuPragmas size}.
				{'Advices' . advicePragmas . advicePragmas size}.
				{'Lepiter snippets' . lepiterSnippets . lepiterSnippets size}.
			} ];
		column: 'Property' text: [ :each | each first ];
		column: 'Value' text: [ :each | each last ];
		send: #second
]

{ #category : #'*GToolkit-Releaser-UI' }
GtImage >> gtTreemapWithAllExtensionsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Extensions treemap';
		stencil: [ self class treemapWithAllExtensions ]
]

{ #category : #'*GToolkit-Releaser-UI' }
GtImage class >> treemapWithAllExtensions [
	| tree |
	tree := GtNestedTreeBuilder new
			data: (Smalltalk allClassesAndTraits select: [:c | 
			{'Gt'.'Bl'.'Br'.'Le'} anySatisfy: [:p |c name beginsWith: p]]);
		groupBy: [ :aClass | aClass package ];
		groupBy: [ :aClass | aClass package classTags detect: [ :e | e hasClass: aClass ] ];
		weight: [ :aClass | aClass methods size max: 1];
		build.
	^ GtNestedRectangleTreeMap new
		roots: { tree };
		leaves: [ :aNode | aNode leaves ];
		deep: [ :aNode | aNode nodes ];
		leavesSize: [ :aNode | aNode weight ];
		containerElement: [ :anElement :aNodeContext | 
			aNodeContext level = 2 ifTrue: [ 
				anElement addChild: (BrLabel new 
					text: (aNodeContext  model name name withoutPrefix: 'GToolkit-'); 
					aptitude: (BrGlamorousLabelAptitude new fontSize: 8; foreground: Color gray); 
					constraintsDo: [ :c | c ignoreByLayout. ])].
			anElement border: (BlBorder 
				paint: (Color gray alpha: 0.7 / aNodeContext level) 
				width: 1).
			anElement padding: (BlInsets all: 1) ];
		leafElement: [ :anElement :aLeafContext | 
			| isGtView isGtExample |
			isGtView := aLeafContext model item itOrItsSuperclassesDefineGTViews.
			isGtExample := aLeafContext model item methods anySatisfy: [ :aMethod | 
				aMethod isGTExampleMethod ].
			anElement border: (BlBorder 
				paint: (Color gray alpha: 0.5 / aLeafContext level) 
				width: 1).
			anElement background: (isGtView 
				ifTrue: [(Color blue alpha: 0.6)] 
				ifFalse: [ 
					isGtExample 
						ifTrue: [ Color green muchDarker alpha: 0.6] 
						ifFalse: [ Color transparent ]]) ].
]
