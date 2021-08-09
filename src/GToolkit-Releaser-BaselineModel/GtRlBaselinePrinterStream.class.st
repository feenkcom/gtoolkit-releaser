"
A stream for creating the source code of baseline methods.

It provides an api to write various parts of a baseline, like:
- {{gtMethod:GtRlBaselinePrinterStream>>preLoadAction:}} Writes a preload load action
- {{gtMethod:GtRlBaselinePrinterStream>>postLoadAction:}} Writes a post load action
- {{gtMethod:GtRlBaselinePrinterStream>>projectDependencyFor:withLoadSpec:}} Writes a dependency to another project
- {{gtMethod:GtRlBaselinePrinterStream>>packageFor:withDependencies: }} Writes a package with a given list of dependencies


"
Class {
	#name : 'GtRlBaselinePrinterStream',
	#superclass : 'Object',
	#instVars : [
		'indentationLevel',
		'stream'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Printer'
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
	self indentedPut: ('spec requires: {1} ].' format: {aCollection asArray storeString}).

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

{ #category : 'api' }
GtRlBaselinePrinterStream >> projectDependencyFor: aProjectName withLoadSpec: aLoadSpecString [
	self newLine.
	self indentedPut: 'spec'. 
	self newLine.
	self indentedPut: ('	baseline: {1} with: [' format: {aProjectName storeString }).
	self newLine.
	self indentedPut: ('		spec repository: {1} ].' format: { aLoadSpecString storeString }).
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream [

	^ stream
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream: anObject [

	stream := anObject
]
