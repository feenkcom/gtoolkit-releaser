Class {
	#name : #JSONCodeGenerator,
	#superclass : #Object,
	#instVars : [
		'packageOrganizer',
		'_parent'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JSONCodeGenerator >> ensureClass: aFullClassName [
	|fullPackageName classSymbol |
	fullPackageName := (aFullClassName findTokens: '.') allButLast 
		fold:[:first :second | first capitalized, second capitalized].
	fullPackageName := 'GToolkit-Releaser-Jenkins-Generated-',fullPackageName.
	self ensurePackage: fullPackageName.
	classSymbol := (aFullClassName findTokens: '.') last.
	^ classSymbol asClassInEnvironment: Smalltalk globals 
		ifAbsent: [ (JenkinsURL subclass: (aFullClassName findTokens: '.') last)
								  category: fullPackageName ].
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
	| theClass theObject|
	aDictionary at: #'_class' ifPresent: [:fullClassName | 
	theClass := (self ensureClass: fullClassName).
	theObject := theClass new.
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_class' ifTrue: [
		self ensureInstVarNamed: key asSymbol inClass: theClass.
		self setAttribute: key toValue: value inObject: theObject]].
	^ theObject].
	^ nil
	
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
				self ensureInstVarNamed: '_parent' inClass: childObject class.
				childObject instVarNamed: '_parent' put: theObject.
				childObject url: key allButLast.
				childObject
				].
			theObject instVarNamed: key asSymbol put: array ]
]

{ #category : #accessing }
JSONCodeGenerator >> updateObject: theObject with: aDictionary [
	aDictionary associations do: [ :assoc | |key value|
		 key := ('_',assoc key).
		 value := assoc value.
		 key ~= '_class' ifTrue: [
		self inform: key.
		self ensureInstVarNamed: (key) asSymbol inClass: theObject class.
		self setAttribute: key toValue: value inObject: theObject]] displayingProgress: [:assoc | |key value|
		 key := assoc key.
		 value := assoc value.
		('importing ' , key)
		].
	^ theObject.

]
