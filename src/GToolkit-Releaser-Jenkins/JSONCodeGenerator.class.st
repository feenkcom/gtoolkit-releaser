Class {
	#name : #JSONCodeGenerator,
	#superclass : #Object,
	#instVars : [
		'packageOrganizer'
	],
	#category : #'GToolkit-Releaser-Jenkins'
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
	|fullClassName|
	fullClassName := aDictionary at: #'_class'.
	^ self ensureClass: fullClassName
]
