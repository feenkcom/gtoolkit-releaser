Class {
	#name : 'GtRlBaselinePrinterStream',
	#superclass : 'Object',
	#instVars : [
		'indentationLevel',
		'stream'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Builder'
}

{ #category : 'api' }
GtRlBaselinePrinterStream >> commonSpecDo: aBlock [

	self indentedPut: 'spec for: #''common'' do: ['.
	self increaseIndentation.
	aBlock value.
	self newLine.
	self decreaseIndentation.
	self indentedPut: ']'.
]

{ #category : 'actions' }
GtRlBaselinePrinterStream >> decreaseIndentation [
	indentationLevel := indentationLevel - 1
]

{ #category : 'actions' }
GtRlBaselinePrinterStream >> increaseIndentation [
	indentationLevel := indentationLevel + 1
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> indentationLevel [

	^ indentationLevel
]

{ #category : 'actions' }
GtRlBaselinePrinterStream >> indentedPut: aString [
	indentationLevel timesRepeat: [ 
		self stream 
			nextPutAll: String tab ].
	self stream 
		nextPutAll: aString
]

{ #category : 'initialization' }
GtRlBaselinePrinterStream >> initialize [ 
	super initialize.
	indentationLevel := 1
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> methodHeader [
	self stream  
		nextPutAll: 'baseline: spec';
		cr;
		nextPutAll: '	';
		nextPutAll: '<baseline>';
		cr.
]

{ #category : 'actions' }
GtRlBaselinePrinterStream >> newLine [
	self stream cr.
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> packageFor: aPackageName withDependencies: aCollection [
	self newLine.
	self indentedPut: ('spec package: {1}' format: {aPackageName asString storeString}).
	aCollection ifEmpty: [
		self stream nextPutAll: '.'.
		^ self ].
	self stream nextPutAll: ' with: [ '.
	self newLine.
	self increaseIndentation.
	self indentedPut: ('spec requires: {1} ]. ' format: {aCollection asArray storeString}).

	self decreaseIndentation.
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> postLoadAction: aSymbol [
	self 
		newLine;
		indentedPut:('spec postLoadDoIt: #''{1}''.' format: {aSymbol}).
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> preLoadAction: aSymbol [
	self 
		newLine;
		indentedPut:('spec preLoadDoIt: #''{1}''.' format: {aSymbol}).
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream [

	^ stream
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream: anObject [

	stream := anObject
]
