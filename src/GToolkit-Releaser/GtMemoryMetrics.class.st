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
GtMemoryMetrics class >> totalClassesInstanceSideSize [
	<gtExample>
	<noTest>
	
	^ self default totalClassesInstanceSideSize
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
GtMemoryMetrics >> computeClasesClasssSideSize [

	^ SystemNavigation default allClasses 
		sum: [ :aClass |
	 		aClass classSide gtSpecificSizeInMemory ]
]

{ #category : #utils }
GtMemoryMetrics >> computeClassesInstanceSideSize [

	^ SystemNavigation default allClasses 
			sum: [ :aClass |
	 			aClass instanceSide gtSpecificSizeInMemory ]
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
			 ClassOrganization allInstances size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassOrganisationInstancesSize [

	^ self 
		cacheAt: #totalClassOrganisationInstancesSize
		ifAbsentPut: [
			 ClassOrganization allInstances 
				sum: [ :aClassOrganization | 
					aClassOrganization gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesClassSideSize [

	^ self 
		cacheAt: #totalClassesClassSideSize
		ifAbsentPut: [
			self computeClasesClasssSideSize ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesCount [

	^ self 
		cacheAt: #totalClassesCount
		ifAbsentPut: [
			SystemNavigation default allClasses size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalClassesInstanceSideSize [

	^ self 
		cacheAt: #totalClassesInstanceSideSize
		ifAbsentPut: [
			self computeClassesInstanceSideSize ]
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
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledMethodInstancesCount [

	^ self 
		cacheAt: #totalCompiledMethodInstancesCount
		ifAbsentPut: [
			 CompiledMethod allInstances size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompiledMethodInstancesSize [

	^ self 
		cacheAt: #totalCompiledMethodInstancesSize
		ifAbsentPut: [
			 CompiledMethod allInstances 
				sum: [ :aCompiledMethod | 
					aCompiledMethod gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalCompleterCacheSize [

	^ self 
		cacheAt: #totalCompleterCacheSize
		ifAbsentPut: [
			 GtPharoCompletionStrategy cacheSizeInMemory ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodDictionaryInstancesCount [

	^ self 
		cacheAt: #totalMethodDictionaryInstancesCount
		ifAbsentPut: [
			 MethodDictionary allInstances size ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalMethodDictionarySize [

	^ self 
		cacheAt: #totalMethodDictionarySize
		ifAbsentPut: [
			 MethodDictionary allInstances 
				sum: [ :aMethodDictionary | 
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
				sum: [ :aMethod | aMethod gtSpecificSizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalPragmasCacheSize [

	^ self 
		cacheAt: #totalPragmasCacheSize
		ifAbsentPut: [
			Pragma pragmaCache gtSpecificSizeInMemory + 
				(Pragma pragmaCache sum: [ :pragmasSet | 
					pragmasSet gtSpecificSizeInMemory +  (pragmasSet sum: #sizeInMemory) ]) ]
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
				sum: [ :aSymbol | aSymbol sizeInMemory ] ]
]

{ #category : #metrics }
GtMemoryMetrics >> totalTraitsOverheadSize [

	^ self 
		cacheAt: #totalTraitsOverheadSize
		ifAbsentPut: [
			self computeTraitsOverheadSize ]
]
