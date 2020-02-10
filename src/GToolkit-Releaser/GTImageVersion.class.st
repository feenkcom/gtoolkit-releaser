Class {
	#name : #GTImageVersion,
	#superclass : #Object,
	#instVars : [
		'version',
		'timestamp'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GTImageVersion class >> instance [ 
	singleton ifNil: [ singleton := self new ].
	^ singleton
]

{ #category : #accessing }
GTImageVersion class >> timestamp: aTimestamp [
	self instance timestamp: aTimestamp
]

{ #category : #accessing }
GTImageVersion class >> version [
	^ self instance
]

{ #category : #accessing }
GTImageVersion class >> version: aVersion [
	self instance version: aVersion
]

{ #category : #accessing }
GTImageVersion >> gtPreviewFor: aView [
	<gtView>
	^ aView explicit
		title: 'Preview';
		stencil: [ 
			| aVersionElement aTimestampElement |
			aVersionElement := BrLabel new 
				text: self version versionString;
				look: BrGlamorousLabelLook + BrShadowLook;
				background: Color white;
				margin: (BlInsets all: 20);
				padding: (BlInsets all: 10);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal fitContent.
					c frame horizontal alignCenter.
					c frame vertical alignCenter ].
			aTimestampElement := BrLabel new 
				text: self timestamp asString;
				look: BrGlamorousLabelLook + BrShadowLook;
				background: Color white;
				margin: (BlInsets all: 20);
				padding: (BlInsets all: 10);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal fitContent.
					c frame horizontal alignCenter.
					c frame vertical alignCenter ].
			BlElement new 
				constraintsDo: [:c | 
					c vertical matchParent.
					c horizontal matchParent];
				layout: BlGridLayout new;
				addChild: aVersionElement; addChild: aTimestampElement  ]
]

{ #category : #accessing }
GTImageVersion >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GTImageVersion >> timestamp: anObject [
	timestamp := anObject
]

{ #category : #accessing }
GTImageVersion >> version [
	^ version
]

{ #category : #accessing }
GTImageVersion >> version: anObject [
	version := anObject
]
