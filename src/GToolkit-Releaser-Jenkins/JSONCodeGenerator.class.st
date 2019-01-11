Class {
	#name : #JSONCodeGenerator,
	#superclass : #Object,
	#instVars : [
		'packageOrganizer'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JSONCodeGenerator >> ensureClass: aFullClassName [
	|fullPackageName classSymbol |
	fullPackageName := (aFullClassName findTokens: '.') allButLast fold:[:first :second| first capitalized, second capitalized].
	self ensurePackage: fullPackageName.
	classSymbol := (aFullClassName findTokens: '.') last.
	^ classSymbol asClassInEnvironment: Smalltalk globals ifAbsent: [ (Object subclass: (aFullClassName findTokens: '.') last) category: fullPackageName. ].
]

{ #category : #accessing }
JSONCodeGenerator >> ensureInstVarNamed: aSymbol inClass: aClass [
	aClass instVarNames detect: [:name | name = aSymbol] ifNone: [ aClass addInstVarNamed: aSymbol ].

]

{ #category : #accessing }
JSONCodeGenerator >> ensurePackage: aFullPackageName [
	^ packageOrganizer ensureExistAndRegisterPackageNamed: aFullPackageName
]

{ #category : #accessing }
JSONCodeGenerator >> initialize [ 
	packageOrganizer := RPackageOrganizer new.
]

{ #category : #accessing }
JSONCodeGenerator >> modelFrom: aDictionary [
	|fullClassName theClass theObject|
	fullClassName := aDictionary at: #'_class'.
	theClass := (self ensureClass: fullClassName).
	theObject := theClass new.
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_class' ifTrue: [
		self ensureInstVarNamed: key asSymbol inClass: theClass.
		self setAttribute: key toValue: value inObject: theObject]].
	^ theObject.
]

{ #category : #reflection }
JSONCodeGenerator >> setAttribute: key toValue: value inObject: theObject [
	value isArray 
		ifFalse: [ theObject instVarNamed: key asSymbol put: value. ];
		ifTrue: [
			| array |
			array := value collect: [ :eachValue | 
				| childObject | 
				childObject := self modelFrom: eachValue.
				childObject instVarNamed: #_parent put: theObject.
				].
			theObject instVarNamed: key asSymbol put: array ]
]
