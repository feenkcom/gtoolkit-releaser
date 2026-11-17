Class {
	#name : #GtMemoryMetrics,
	#superclass : #Object,
	#instVars : [
		'cache'
	],
	#classInstVars : [
		'default'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtMemoryMetrics class >> default [
	<gtExample>
	^ default ifNil: [ default := self new ]
]

{ #category : #metrics }
GtMemoryMetrics class >> navigationEnvironmentSize [
	<gtExample>
	<noTest>
	
	^ self default navigationEnvironmentSize
]

{ #category : #accessing }
GtMemoryMetrics class >> reset [
	default := nil
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesBasicSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesBasicSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideBasicSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideBasicSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideByComponentsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideByComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideBySubComponentsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideBySubComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideLayoutSize [
	<gtExample>
	<noTest>
	 
	^ self default totalClassesClassSideLayoutSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideMethodDictionariesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideProtocolsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideProtocolsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesClassSideWithoutMethodDictionariesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesClassSideWithoutMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesCount [
	<gtExample>
	<noTest>
	
	^ self default totalClassesCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideBasicSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideBasicSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideByComponentsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideByComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideBySubComponentsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideBySubComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideLayoutSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideLayoutSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideMethodDictionariesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideProtocolsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideProtocolsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideSharedPoolsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideSharedPoolsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideSubclassesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideSubclassesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesInstanceSideWithoutMethodDictionariesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideWithoutMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesLayoutSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesLayoutSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesMethodDictionariesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesProtocolsSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesProtocolsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCodeAnalysedSize [
	<gtExample>
	<noTest>
	
	^ self default totalCodeAnalysedSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompiledBlockBasicInstancesSize [
	<gtExample>
	<noTest>
	
	^ self default totalCompiledBlockBasicInstancesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompiledBlockInstancesCount [
	<gtExample>
	<noTest>
	
	^ self default totalCompiledBlockInstancesCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompiledMethodBasicInstancesSize [
	<gtExample>
	<noTest>
	
	^ self default totalCompiledMethodBasicInstancesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompiledMethodInstancesCount [
	<gtExample>
	<noTest>
	
	^ self default totalCompiledMethodInstancesCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompiledMethodInstancesSize [
	<gtExample>
	<noTest>
	
	^ self default totalCompiledMethodInstancesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalCompleterCacheSize [
	<gtExample>
	<noTest>
	
	^ self default totalCompleterCacheSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalHeapSize [
	"The current size of the heap. Besides the objects saved in the image, 
	it also includes free space and objects created by the UI and the user."

	<gtExample>
	<noTest>
	^ Smalltalk vm memorySize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalImageSize [
	"The size of the image file on disk, as of the last save"

	<gtExample>
	<noTest>
	^ Smalltalk imagePath asFileReference size
]

{ #category : #metrics }
GtMemoryMetrics class >> totalImageSizeInMemory [
	<gtExample>
	<noTest>
	^ self default totalImageSizeInMemory
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodDictionaryBasicSize [
	<gtExample>
	<noTest>
	
	^ self default totalMethodDictionaryBasicSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodDictionaryInstancesCount [
	<gtExample>
	<noTest>
	
	^ self default totalMethodDictionaryInstancesCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodDictionarySize [
	<gtExample>
	<noTest>
	
	^ self default totalMethodDictionarySize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodsCount [
	<gtExample>
	<noTest>
	
	^ self default totalMethodsCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodsFromTraitsCount [
	<gtExample>
	<noTest>
	^ self default totalMethodsFromTraitsCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodsFromTraitsSize [
	<gtExample>
	<noTest>
	^ self default totalMethodsFromTraitsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalMethodsSize [
	<gtExample>
	<noTest>
	
	^ self default totalMethodsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalPackagesSize [
	<gtExample>
	<noTest>
	
	^ self default totalPackagesSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalPragmasCacheSize [
	<gtExample>
	<noTest>
	
	^ self default totalPragmasCacheSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalStringLiteralsOnlyInMethodsSize [
	<gtExample>
	<noTest>
	
	^ self default totalStringLiteralsOnlyInMethodsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalSymbolsCount [
	<gtExample>
	<noTest>
	
	^ self default totalSymbolsCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalSymbolsSize [
	<gtExample>
	<noTest>
	
	^ self default totalSymbolsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalTraitsOverheadForClassesWithoutTraitsSize [
	<gtExample>
	<noTest>
	^ self default totalTraitsOverheadForClassesWithoutTraitsSize
]

{ #category : #metrics }
GtMemoryMetrics class >> totalTraitsOverheadSize [
	<gtExample>
	<noTest>
	
	^ self default totalTraitsOverheadSize
]

{ #category : #accessing }
GtMemoryMetrics >> cache [
	^ cache
]

{ #category : #accessing }
GtMemoryMetrics >> cacheAt: aSymbol ifAbsentPut: aBlock [
	^ self cache 
		at: aSymbol ifAbsentPut: aBlock
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideBasicSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass classSide sizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideLayoutSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		(aClass classSide instVarNamed: #layout)
	 				ifNil: [ 0 ] 
	 				ifNotNil: [ :each | each gtSpecificSizeInMemory ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideMethodDictionariesSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass classSide methodDict gtSpecificSizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideProtocolsSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass classSide gtSpecificSizeInMemoryForProtocols ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideSharedPoolsSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass classSide basicSharedPools 
	 			ifNil: [ 0 ] ifNotNil: [ :each | each gtSpecificSizeInMemory ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesClassSideSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass classSide gtSpecificSizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideBasicSize [

	^ SystemNavigation default allClasses 
			sumNumbers: [ :aClass |
	 			aClass instanceSide sizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideLayoutSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		(aClass instanceSide instVarNamed: #layout)
	 				ifNil: [ 0 ] 
	 				ifNotNil: [ :each | each gtSpecificSizeInMemory ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideMethodDictionariesSize [

	^ SystemNavigation default allClasses 
			sumNumbers: [ :aClass |
	 			aClass instanceSide methodDict gtSpecificSizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideProtocolsSize [

	^ SystemNavigation default allClasses 
			sumNumbers: [ :aClass |
	 			aClass instanceSide gtSpecificSizeInMemoryForProtocols ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideSharedPoolsSize [

	^ SystemNavigation default allClasses 
		sumNumbers: [ :aClass |
	 		aClass instanceSide basicSharedPools 
	 			ifNil: [ 0 ] ifNotNil: [ :each | each gtSpecificSizeInMemory ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideSize [

	^ SystemNavigation default allClasses 
			sumNumbers: [ :aClass |
	 			aClass instanceSide gtSpecificSizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideSubclassesSize [

	^ SystemNavigation default allClasses 
			sumNumbers: [ :aClass |
	 			(aClass instanceSide instVarNamed: #subclasses)
	 			ifNil: [ 0 ] 
	 			ifNotNil: [ :each | each sizeInMemory ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeTraitsOverheadForClassesWithoutTraitsSize [
	"Classes (and traits) that do not use traits themselves, neither on the instance side 
	nor on the class side, can still have a TraitedMetaclass, for example because they 
	inherit from a class that uses traits. 
	Their extra method dictionaries contain the same methods as their method dictionaries."

	^ SystemNavigation default allClasses
		sumNumbers: [ :aClass | 
			(aClass hasTraitComposition or: [ aClass classSide hasTraitComposition ])
				ifTrue: [ 0 ]
				ifFalse: [ self traitsOverheadSizeFor: aClass ] ]
]

{ #category : #utils }
GtMemoryMetrics >> computeTraitsOverheadSize [
	"Count the extra method dictionaries once for every class that has a TraitedMetaclass."

	^ SystemNavigation default allClasses
		sumNumbers: [ :aClass | self traitsOverheadSizeFor: aClass ]
]

{ #category : #initialization }
GtMemoryMetrics >> initialize [ 
	super initialize.
	cache := Dictionary new.
]

{ #category : #utils }
GtMemoryMetrics >> methodsFromTraitsDo: aBlock [
	"Evaluate aBlock with every method installed in a class from a trait.
	Traits can be used on the instance side or on the class side. The class side of traits 
	also gets the methods of TraitedClass. Only classes with a TraitedMetaclass can have such methods."

	SystemNavigation default allClasses
		do: [ :aClass | 
			(aClass classSide isKindOf: TraitedMetaclass)
				ifTrue: [ {aClass instanceSide.
						aClass classSide}
						do: [ :aBehavior | 
							aBehavior methodDict
								valuesDo: [ :aMethod | aMethod isFromTrait ifTrue: [ aBlock value: aMethod ] ] ] ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> navigationEnvironmentSize [

	^ self 
		cacheAt: #navigationEnvironmentSize
		ifAbsentPut: [
			 SystemNavigation default environment gtSpecificSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesBasicSize [
	
	^ self totalClassesClassSideBasicSize  + self totalClassesInstanceSideBasicSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideBasicSize [

	^ self 
		cacheAt: #totalClassesClassSideBasicSize
		ifAbsentPut: [
			self computeClassesClassSideBasicSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideByComponentsSize [

	^ self totalClassesClassSideBasicSize
		+ self totalClassesClassSideMethodDictionariesSize
		+ self totalClassesClassSideBySubComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideBySubComponentsSize [

	^ self totalClassesClassSideProtocolsSize
		+ self totalClassesClassSideLayoutSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideLayoutSize [

	^ self 
		cacheAt: #totalClassesClassSideLayoutSize
		ifAbsentPut: [
			self computeClassesClassSideLayoutSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideMethodDictionariesSize [

	^ self 
		cacheAt: #totalClassesClassSideMethodDictionariesSize
		ifAbsentPut: [
			self computeClassesClassSideMethodDictionariesSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideProtocolsSize [

	^ self 
		cacheAt: #totalClassesClassSideProtocolsSize
		ifAbsentPut: [
			self computeClassesClassSideProtocolsSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideSize [

	^ self 
		cacheAt: #totalClassesClassSideSize
		ifAbsentPut: [
			self computeClassesClassSideSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideWithoutMethodDictionariesSize [

	^ self totalClassesClassSideSize - self totalClassesClassSideMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesCount [

	^ self 
		cacheAt: #totalClassesCount
		ifAbsentPut: [
			SystemNavigation default allClasses size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideBasicSize [

	^ self 
		cacheAt: #totalClassesInstanceSideBasicSize
		ifAbsentPut: [
			self computeClassesInstanceSideBasicSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideByComponentsSize [

	^ self totalClassesInstanceSideBasicSize
		+ self totalClassesInstanceSideMethodDictionariesSize
		+ self totalClassesInstanceSideBySubComponentsSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideBySubComponentsSize [

	^ self totalClassesInstanceSideSubclassesSize
		+ self totalClassesInstanceSideProtocolsSize
		+ self totalClassesInstanceSideLayoutSize
		+ self totalClassesInstanceSideSharedPoolsSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideLayoutSize [

	^ self 
		cacheAt: #totalClassesInstanceSideLayoutSize
		ifAbsentPut: [
			self computeClassesInstanceSideLayoutSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideMethodDictionariesSize [

	^ self 
		cacheAt: #totalClassesInstanceSideMethodDictionariesSize
		ifAbsentPut: [
			self computeClassesInstanceSideMethodDictionariesSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideProtocolsSize [

	^ self 
		cacheAt: #totalClassesInstanceSideProtocolsSize
		ifAbsentPut: [
			self computeClassesInstanceSideProtocolsSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideSharedPoolsSize [

	^ self 
		cacheAt: #totalClassesInstanceSideSharedPoolsSize
		ifAbsentPut: [
			self computeClassesInstanceSideSharedPoolsSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideSize [

	^ self 
		cacheAt: #totalClassesInstanceSideSize
		ifAbsentPut: [
			self computeClassesInstanceSideSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideSubclassesSize [

	^ self 
		cacheAt: #totalClassesInstanceSideSubclassesSize
		ifAbsentPut: [
			self computeClassesInstanceSideSubclassesSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideWithoutMethodDictionariesSize [

	^ self totalClassesInstanceSideSize - self totalClassesInstanceSideMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesLayoutSize [
	
	^ self totalClassesClassSideLayoutSize  + self totalClassesInstanceSideLayoutSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesMethodDictionariesSize [
	
	^ self totalClassesClassSideMethodDictionariesSize  
		+ self totalClassesInstanceSideMethodDictionariesSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesProtocolsSize [
	
	^ self totalClassesClassSideProtocolsSize  + self totalClassesInstanceSideProtocolsSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesSize [
	
	^ self totalClassesClassSideSize  + self totalClassesInstanceSideSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalCodeAnalysedSize [
	
	^ self totalClassesSize 
		+ self totalMethodsSize 
		+ self totalSymbolsSize 
		+ self totalPragmasCacheSize
		+ self totalCompleterCacheSize
		+ self navigationEnvironmentSize
		+ self totalPackagesSize
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledBlockBasicInstancesSize [

	^ self 
		cacheAt: #totalCompiledBlockBasicInstancesSize
		ifAbsentPut: [
			 CompiledBlock instancesSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledBlockInstancesCount [

	^ self 
		cacheAt: #totalCompiledBlockInstancesCount
		ifAbsentPut: [
			 CompiledBlock instanceCount ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledMethodBasicInstancesSize [

	^ self 
		cacheAt: #totalCompiledMethodBasicInstancesSize
		ifAbsentPut: [
			 CompiledMethod instancesSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledMethodInstancesCount [

	^ self 
		cacheAt: #totalCompiledMethodInstancesCount
		ifAbsentPut: [
			 CompiledMethod instanceCount ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledMethodInstancesSize [

	^ self 
		cacheAt: #totalCompiledMethodInstancesSize
		ifAbsentPut: [
			 CompiledMethod allInstances 
				sumNumbers: [ :aCompiledMethod | 
					aCompiledMethod gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompleterCacheSize [

	^ self 
		cacheAt: #totalCompleterCacheSize
		ifAbsentPut: [
			 GtPharoIndex cacheSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalImageSizeInMemory [
	"The memory used now by all objects in the image, after a full garbage collection.
	This is close to what saving the image now would write to disk. 
	It also includes objects created by the UI and the user, but not the free space of the heap."

	^ self
		cacheAt: #totalImageSizeInMemory
		ifAbsentPut: [ | aVirtualMachine |
			Smalltalk garbageCollect.
			aVirtualMachine := Smalltalk vm.
			aVirtualMachine oldSpace - aVirtualMachine freeOldSpaceSize
				+ aVirtualMachine youngSpaceSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodDictionaryBasicSize [

	^ self 
		cacheAt: #totalMethodDictionaryBasicSize
		ifAbsentPut: [
			 MethodDictionary instancesSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodDictionaryInstancesCount [

	^ self 
		cacheAt: #totalMethodDictionaryInstancesCount
		ifAbsentPut: [
			 MethodDictionary instanceCount ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodDictionarySize [

	^ self 
		cacheAt: #totalMethodDictionarySize
		ifAbsentPut: [
			 MethodDictionary allInstances 
				sumNumbers: [ :aMethodDictionary | 
					aMethodDictionary gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodsCount [

	^ self 
		cacheAt: #totalMethodsCount
		ifAbsentPut: [
			SystemNavigation default allMethods size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodsFromTraitsCount [
	^ self
		cacheAt: #totalMethodsFromTraitsCount
		ifAbsentPut: [ | count |
			count := 0.
			self methodsFromTraitsDo: [ :aMethod | count := count + 1 ].
			count ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodsFromTraitsSize [
	^ self
		cacheAt: #totalMethodsFromTraitsSize
		ifAbsentPut: [ | size |
			size := 0.
			self
				methodsFromTraitsDo: [ :aMethod | size := size + aMethod gtSpecificSizeInMemory ].
			size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodsSize [

	^ self 
		cacheAt: #totalMethodsSize
		ifAbsentPut: [
			SystemNavigation default  allMethods 
				sumNumbers: [ :aMethod | aMethod gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalPackagesSize [

	^ self 
		cacheAt: #totalPackagesSize
		ifAbsentPut: [
			 self class packageOrganizer gtSpecificSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalPragmasCacheSize [
	"Only the structure of the cache: the dictionary and the sets of pragmas.
	The pragma objects are counted as part of the methods that define them."

	^ self
		cacheAt: #totalPragmasCacheSize
		ifAbsentPut: [ Pragma pragmaCache gtSpecificSizeInMemory
				+ (Pragma pragmaCache
						sumNumbers: [ :pragmasSet | pragmasSet gtSpecificSizeInMemory ]) ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalStringLiteralsOnlyInMethodsSize [

	^ self 
		cacheAt: #totalStringLiteralsOnlyInMethodsSize
		ifAbsentPut: [
			SystemNavigation default  allMethods 
				sumNumbers: [ :aMethod | aMethod gtSpecificSizeInMemoryStringLiteralsOnly ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalSymbolsCount [

	^ self 
		cacheAt: #totalSymbolsCount
		ifAbsentPut: [
			Symbol allSymbols size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalSymbolsSize [

	^ self 
		cacheAt: #totalSymbolsSize
		ifAbsentPut: [
			Symbol allSymbols 
				sumNumbers: [ :aSymbol | aSymbol sizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalTraitsOverheadForClassesWithoutTraitsSize [
	^ self
		cacheAt: #totalTraitsOverheadForClassesWithoutTraitsSize
		ifAbsentPut: [ self computeTraitsOverheadForClassesWithoutTraitsSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalTraitsOverheadSize [

	^ self 
		cacheAt: #totalTraitsOverheadSize
		ifAbsentPut: [
			self computeTraitsOverheadSize ]
]

{ #category : #utils }
GtMemoryMetrics >> traitsOverheadSizeFor: aClass [
	"Classes that use traits, or inherit from a class that uses traits, have a TraitedMetaclass.
	It keeps two extra method dictionaries with the methods defined locally in the class,
	for the instance side and for the class side."

	| aMetaclass |
	aMetaclass := aClass classSide.
	(aMetaclass isKindOf: TraitedMetaclass) ifFalse: [ ^ 0 ].

	^ (aMetaclass localMethodDict
		ifNil: [ 0 ]
		ifNotNil: [ :aDictionary | aDictionary gtSpecificSizeInMemory ])
		+ (aMetaclass baseLocalMethods
				ifNil: [ 0 ]
				ifNotNil: [ :aDictionary | aDictionary gtSpecificSizeInMemory ])
]
