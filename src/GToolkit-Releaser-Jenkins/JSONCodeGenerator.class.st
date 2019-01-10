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
	|fullPackageName|
	fullPackageName := (aFullClassName findTokens: '.') allButLast fold:[:first :second| first capitalized, second capitalized].
	self ensurePackage: fullPackageName.
	^ (Object subclass: (aFullClassName findTokens: '.') last) category: fullPackageName.
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
			theClass addInstVarNamed: key.
			] ].
	^ theObject.
]
