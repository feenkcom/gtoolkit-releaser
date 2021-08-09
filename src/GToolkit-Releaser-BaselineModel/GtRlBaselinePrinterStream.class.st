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

	self indentedPut: ('{1} for: #''common'' do: [' 
		format: { self specVariableName }).
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
		nextPutAll: ('baseline: {1}' format: { self specVariableName });
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
	self indentedPut: ('{1} package: {2}' 
		format: {self specVariableName. aPackageName asString storeString}).
	aCollection ifEmpty: [
		self stream nextPutAll: '.'.
		^ self ].
	self stream nextPutAll: ' with: [ '.
	self newLine.
	
	self increaseIndentation.
	self indentedPut: ('{1} requires: {2} ].' 
		format: {self specVariableName. aCollection asArray storeString}).

	self decreaseIndentation.
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> postLoadAction: aSymbol [
	self 
		newLine;
		indentedPut: ('{1} postLoadDoIt: #''{2}''.' 
			format: {self specVariableName. aSymbol}).
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> preLoadAction: aSymbol [
	self 
		newLine;
		indentedPut:('{1} preLoadDoIt: #''{2}''.' 
			format: {self specVariableName. aSymbol}).
]

{ #category : 'api' }
GtRlBaselinePrinterStream >> projectDependencyFor: aProjectName withLoadSpec: aLoadSpecString [
	self newLine.
	self indentedPut: self specVariableName. 
	self newLine.
	self indentedPut: ('	baseline: {1} with: [' format: {aProjectName storeString }).
	self newLine.
	self indentedPut: ('		{1} repository: {2} ].' 
		format: {self specVariableName. aLoadSpecString storeString }).
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> specVariableName [
	^ 'spec'
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream [

	^ stream
]

{ #category : 'accessing' }
GtRlBaselinePrinterStream >> stream: anObject [

	stream := anObject
]
