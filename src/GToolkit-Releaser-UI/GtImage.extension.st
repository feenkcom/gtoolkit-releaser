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
