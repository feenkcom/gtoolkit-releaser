Class {
	#name : #JSONCodeGenerator,
	#superclass : #Object,
	#instVars : [
		'packageOrganizer',
		'_parent',
		'znclient',
		'currentWfJobRun'
	],
	#category : #'GToolkit-Releaser-Jenkins-Generator'
}

{ #category : #accessing }
JSONCodeGenerator >> currentWfJobRun [
	^ currentWfJobRun
]

{ #category : #accessing }
JSONCodeGenerator >> ensureClass: aFullClassName [
	|fullPackageName classSymbol |
	fullPackageName := (aFullClassName findTokens: '.') allButLast 
		fold:[:first :second | first capitalized, second capitalized].
	fullPackageName := 'GToolkit-Releaser-Jenkins-Generated-',fullPackageName.
	self ensurePackage: fullPackageName.
	classSymbol := (aFullClassName findTokens: '.') last.
	classSymbol := classSymbol copyReplaceAll: '$' with: '_'.
	^ classSymbol asClassInEnvironment: Smalltalk globals 
		ifAbsent: [ (JenkinsURL subclass: classSymbol)
								  category: fullPackageName ].
]

{ #category : #accessing }
JSONCodeGenerator >> ensureInstVarNamed: aSymbol inClass: aClass [
	((aClass instVarNames ), (aClass superclass instVarNames)) detect: [:name | name = aSymbol] ifNone: [ aClass addInstVarNamed: aSymbol ].

]

{ #category : #accessing }
JSONCodeGenerator >> ensurePackage: aFullPackageName [
	^ packageOrganizer ensureExistAndRegisterPackageNamed: aFullPackageName
]

{ #category : #accessing }
JSONCodeGenerator >> ensureWfClass: aFullClassName [
	|fullPackageName classSymbol |
	fullPackageName := 'GToolkit-Releaser-Jenkins-Generated-Wfapi'.
	self ensurePackage: fullPackageName.
	classSymbol := aFullClassName.
	^ classSymbol asClassInEnvironment: Smalltalk globals 
		ifAbsent: [ (JenkinsWFAPI subclass: classSymbol)
								  category: fullPackageName ].
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
	"(theObject znclient: self znclient)."
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_class' ifTrue: [
		|varname|
		varname := ('_',key) asSymbol.
		self ensureInstVarNamed: varname inClass: theClass.
		self setAttribute: varname toValue: value inObject: theObject]].
	^ theObject].
	^ nil
	
]

{ #category : #accessing }
JSONCodeGenerator >> modelFrom: aDictionary className: aClassName [
	| theClass theObject|
	theClass := (self ensureWfClass: aClassName).
	theObject := theClass new.
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_self' ifTrue: [
		|varname|
		varname := (key) asSymbol.
		key ~= '_links' ifTrue: [
			self ensureInstVarNamed: varname inClass: theClass.].
		self setWfAttribute: varname toValue: value inObject: theObject]].
	^ theObject.

]

{ #category : #accessing }
JSONCodeGenerator >> modelFrom: aDictionary className: aClassName znclient: aZnclient [
	| theClass theObject|
	theClass := (self ensureWfClass: aClassName).
	theObject := theClass new.
	^ self modelFrom: aDictionary theObject: theObject znclient: aZnclient

]

{ #category : #accessing }
JSONCodeGenerator >> modelFrom: aDictionary theObject: theObject znclient: aZnclient [
	| theClass |
	theClass := theObject class.
	theObject znclient: aZnclient.
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_self' ifTrue: [
		|varname|
		varname := (key) asSymbol.
		key ~= '_links' ifTrue: [
			self ensureInstVarNamed: varname inClass: theClass.].
		self setWfAttribute: varname toValue: value inObject: theObject]].
	^ theObject.

]

{ #category : #accessing }
JSONCodeGenerator >> modelFrom: aDictionary znclient: znclient [
	| theClass theObject|
	aDictionary at: #'_class' ifPresent: [:fullClassName | 
	theClass := (self ensureClass: fullClassName).
	theObject := theClass new.
	(theObject znclient: znclient).
	aDictionary keysAndValuesDo: [ :key :value | key ~= '_class' ifTrue: [
		|varname|
		varname := ('_',key) asSymbol.
		self ensureInstVarNamed: varname inClass: theClass.
		self setAttribute: varname toValue: value inObject: theObject]].
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
				eachValue isDictionary ifTrue: [ 
					childObject := self modelFrom: eachValue.
					childObject isNotNil ifTrue: [ 
						self ensureInstVarNamed: '_parent' inClass: childObject class.
						childObject instVarNamed: '_parent' put: theObject.
						childObject url: (key allButLast) allButFirst].
					childObject]].
			theObject instVarNamed: key asSymbol put: array ]
]

{ #category : #accessing }
JSONCodeGenerator >> setCurrentWfJobRun: anObject [
	currentWfJobRun := anObject
]

{ #category : #accessing }
JSONCodeGenerator >> setWfAttribute: key toValue: value inObject: theObject [
	value isArray 
		ifFalse: [ theObject instVarNamed: key asSymbol put: value. ];
		ifTrue: [
			| array newClassName |
			newClassName := (theObject className, key allButLast capitalized).
			theObject class = WfJobRun ifTrue:[
				self setCurrentWfJobRun: theObject.
			].
			
			array := value collect: [ :eachValue | 
				| childObject | 
				eachValue isDictionary ifTrue: [
					childObject := self modelFrom: eachValue className: newClassName znclient: theObject znclient.
					self currentWfJobRun isNotNil ifTrue:[
						childObject setWfJobRun: self currentWfJobRun.
					]].
				childObject class = WfJobRunStage ifTrue:[
					theObject registerNode: childObject.
				].
			   "key = 'parentIds' ifTrue: [self halt]."
				 "childObject:=eachValue."
				eachValue isNumber ifTrue: [childObject:=eachValue].
				eachValue isString ifTrue: [childObject:=eachValue].
				childObject].
			key = 'parentIds' ifTrue:[
				NonInteractiveTranscript stdout crShow: value asString.
			].
			theObject instVarNamed: key asSymbol put: array ]
]

{ #category : #accessing }
JSONCodeGenerator >> updateObject: theObject with: aDictionary [
	aDictionary associations do: [ :assoc | |key value|
		 key := ('_',assoc key).
		 value := assoc value.
		 key ~= '_class' ifTrue: [
			
		 	self ensureInstVarNamed: (key) asSymbol inClass: theObject class.
		 	self setAttribute: key toValue: value inObject: theObject]]
		 displayingProgress: [:assoc | |key value|
		 	key := assoc key.
		 	value := assoc value.
			('importing ' , key)].
	^ theObject.

]

{ #category : #accessing }
JSONCodeGenerator >> znclient [
	^ znclient
]

{ #category : #accessing }
JSONCodeGenerator >> znclient: aZnclient [
	^ znclient := aZnclient
]
