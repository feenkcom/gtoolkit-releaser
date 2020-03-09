Class {
	#name : #GtJenkinsClientSnippet,
	#superclass : #GtSnippet,
	#instVars : [
		'url',
		'user',
		'token'
	],
	#category : #'GToolkit-Releaser-Jenkins'
}

{ #category : #accessing }
GtJenkinsClientSnippet class >> typeName [
	<return: #String>

	^ 'jenkins'
]

{ #category : #converting }
GtJenkinsClientSnippet >> asElement [
	| snippetContainer formElement urlInputElement tokenInputElement toolbar playInspectButton userInputElement |
	formElement := BlElement new.
	formElement constraintsDo: [ :c |  
		c vertical fitContent.
		c horizontal matchParent ].
	formElement layout: (BlGridLayout horizontal columnCount: 2; cellSpacing: 10).

	urlInputElement := self inputElementNamed: 'Url' in: formElement.
	userInputElement := self inputElementNamed: 'User' in: formElement.
	tokenInputElement := self inputElementNamed: 'Token' in: formElement.
	
	toolbar := BrToolbar new
		look: BrToolbarLook new;
		layout: (BlGridLayout horizontal rowCount: 1; cellSpacing: 10);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	playInspectButton := BrButton new.
	playInspectButton 
		beSmall;
		look: BrGlamorousButtonWithIconLook;
		label: 'Inspect connection';
		icon: BrGlamorousIcons playinspect asElement;
		action: [ 
			| client  |
			client := JenkinsClient new
				username: userInputElement editor text asString
				token: tokenInputElement editor text asString
				url: urlInputElement editor text asString.
			playInspectButton phlow spawnObject: client blueOcean ].
	toolbar addItem: playInspectButton.
	
	snippetContainer := BrVerticalPane new
		vFitContent;
		hMatchParent;
		clipChildren: false;
		look: (GtSnippetContainerLook new snippet: self) + BrShadowLook new;
		border: BlBorder empty;
		padding: BlInsets empty;
		background: (BlBackground paint: Color white).
	snippetContainer addChild: formElement.
	snippetContainer addChild: toolbar.
	^ snippetContainer
]

{ #category : #converting }
GtJenkinsClientSnippet >> asStencilBuilder [
	^ self
]

{ #category : #converting }
GtJenkinsClientSnippet >> bind: aSnippet to: aSnippetElement [
]

{ #category : #converting }
GtJenkinsClientSnippet >> inputElementNamed: aString in: formElement [
	| labelElement inputElement text |
	labelElement := BrLabel new text: aString, ':'; look: BrGlamorousLabelLook.
	labelElement constraintsDo: [ :c | 
		c vertical fitContent.
		c horizontal fitContent.
		c grid vertical alignCenter ].
	inputElement := BrEditorElement new.
	inputElement look: BrGlamorousInputFieldSpacingLook.
	inputElement constraintsDo: [ :c | 
		c vertical fitContent.
		c horizontal matchParent.
		c grid vertical alignCenter ].
	text := '' asRopedText 
		weight: 400;
		fontName: 'Source Sans Pro';
		fontSize: 14.
	inputElement editor: (BrTextEditor new text: text).
	formElement addChild: labelElement.
	formElement addChild: inputElement.
	^ inputElement
]

{ #category : #accessing }
GtJenkinsClientSnippet >> token [
	^ token
]

{ #category : #accessing }
GtJenkinsClientSnippet >> token: anObject [
	token := anObject
]

{ #category : #accessing }
GtJenkinsClientSnippet >> url [
	^ url
]

{ #category : #accessing }
GtJenkinsClientSnippet >> url: anObject [
	url := anObject
]

{ #category : #accessing }
GtJenkinsClientSnippet >> user [
	^ user
]

{ #category : #accessing }
GtJenkinsClientSnippet >> user: anObject [
	user := anObject
]
