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
GtMemoryMetrics class >> totalClassOrganisationInstancesCount [
	<gtExample>
	<noTest>
	
	^ self default totalClassOrganisationInstancesCount
]

{ #category : #metrics }
GtMemoryMetrics class >> totalClassOrganisationInstancesSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassOrganisationInstancesSize
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
GtMemoryMetrics class >> totalImageSize [
	<gtExample>
	<noTest>
	
	^ Smalltalk vm memorySize
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
GtMemoryMetrics >> computeTraitsOverheadSize [
	| targetTraits |
	
	targetTraits := Smalltalk allClasses 
		select: [ :class | class isTrait ].
	targetTraits remove: TraitedClass.

	^ targetTraits  
		inject: 0
		into: [ :traitsOverheadSize :targetTrait | 
			traitsOverheadSize + (targetTrait users  
				inject: 0
				into: [ :traitUsersSize :targetClass | 
					traitUsersSize 
						+ targetClass class localMethodDict gtSpecificSizeInMemory
						+ targetClass class baseLocalMethods gtSpecificSizeInMemory ]) ]
]

{ #category : #initialization }
GtMemoryMetrics >> initialize [ 
	super initialize.
	cache := Dictionary new.
]

{ #category : #metrics }
GtMemoryMetrics >> navigationEnvironmentSize [

	^ self 
		cacheAt: #navigationEnvironmentSize
		ifAbsentPut: [
			 SystemNavigation default environment gtSpecificSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassOrganisationInstancesCount [

	^ self 
		cacheAt: #totalClassOrganisationInstancesCount
		ifAbsentPut: [
			 ClassOrganization instanceCount ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassOrganisationInstancesSize [

	^ self 
		cacheAt: #totalClassOrganisationInstancesSize
		ifAbsentPut: [
			 ClassOrganization allInstances 
				sumNumbers: [ :aClassOrganization | 
					aClassOrganization gtSpecificSizeInMemory ] ]
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
		+ self totalClassesClassSideProtocolsSize
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
		+ self totalClassesInstanceSideSubclassesSize
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

	^ self 
		cacheAt: #totalPragmasCacheSize
		ifAbsentPut: [
			Pragma pragmaCache gtSpecificSizeInMemory + 
				(Pragma pragmaCache sumNumbers: [ :pragmasSet | 
					pragmasSet gtSpecificSizeInMemory +  (pragmasSet sumNumbers: #sizeInMemory) ]) ]
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
GtMemoryMetrics >> totalTraitsOverheadSize [

	^ self 
		cacheAt: #totalTraitsOverheadSize
		ifAbsentPut: [
			self computeTraitsOverheadSize ]
]
