Class {
	#name : #GtRlSemanticVersionNumberExamples,
	#superclass : #GtRlVersionNumberExamples,
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
GtRlSemanticVersionNumberExamples >> assertSemanticVersion: versionNumber withMajor: majorNumer minor: minorNumber patch: patchNuber [
	| expectedVersionString |
	
	expectedVersionString := 'v', majorNumer asString ,'.', minorNumber asString ,'.', patchNuber asString.
	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: expectedVersionString.
	self assert: versionNumber versionString equals: expectedVersionString.
	self assert: versionNumber major equals: majorNumer.
	self assert: versionNumber minor equals: minorNumber.
	self assert: versionNumber patch equals: patchNuber.
	
	^ versionNumber
	
]

{ #category : #'examples - factory' }
GtRlSemanticVersionNumberExamples >> createSemanticVersionWithComponents: anArray [
	<gtExample>
	self assert: [ anArray size = 3 ].
	
	^ self createSemanticVersionWithMajor: anArray first 
		minor: anArray second  
		patch: anArray third 
]

{ #category : #'examples - factory' }
GtRlSemanticVersionNumberExamples >> createSemanticVersionWithMajor: majorNumber minor: minorNumber patch: patchNumber [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber 
		major: majorNumber
		minor: minorNumber 
		patch: patchNumber.
	
	self 
		assertSemanticVersion: versionNumber 
		withMajor: majorNumber 
		minor: minorNumber 
		patch: patchNumber.
	
	^ versionNumber
]

{ #category : #'examples - equality' }
GtRlSemanticVersionNumberExamples >> semanticVersionNotEqualsWithVersionsWithDifferentNumbers [
	<gtExample>
	| versionNumber anotherNotEqualVersion1 anotherNotEqualVersion2 anotherNotEqualVersion3 |
	versionNumber := self semanticVersionNumberMajor1Minor2Patch3.
	
	anotherNotEqualVersion1 := self semanticVersionNumberMajor2Minor2Patch3.
	anotherNotEqualVersion2 := self semanticVersionNumberMajor1Minor3Patch3.
	anotherNotEqualVersion3 := self semanticVersionNumberMajor1Minor2Patch4.
	
	self assert: (versionNumber = anotherNotEqualVersion1) not.
	self assert: (versionNumber = anotherNotEqualVersion2) not.
	self assert: (versionNumber = anotherNotEqualVersion3) not.
	
	^ versionNumber
	
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumber [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 1 minor: 2 patch: 3.

	self assert: versionNumber versionString equals: 'v1.2.3'.
	self assert: versionNumber major equals: 1.
	self assert: versionNumber minor equals: 2.
	self assert: versionNumber patch equals: 3.
	^ versionNumber
]

{ #category : #'examples - equality' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberEqualWithItself [
	<gtExample>
	| versionNumber |
	versionNumber := self semanticVersionNumberMajor1Minor2Patch3.
	self assert: versionNumber = versionNumber.
	^ versionNumber
	
]

{ #category : #'examples - equality' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberEqualWithTheSameVersion [
	<gtExample>
	| versionNumber anotherEqualVersion |
	versionNumber := self semanticVersionNumberMajor1Minor2Patch3.
	anotherEqualVersion := self createSemanticVersionWithMajor: 1 minor: 2 patch: 3. "Ensure a new object"
	
	self assert: versionNumber ~~ anotherEqualVersion.
	self assert: versionNumber = anotherEqualVersion.
	
	^ versionNumber
	
]

{ #category : #'examples - comparison' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberGreaterThenComparison [
	<gtExample>
	| anotherVersionM2M2P3 anotherVersionM1M3P3 anotherVersionM1M2P4 anotherVersionM1M2P5 |
	anotherVersionM2M2P3 := self semanticVersionNumberMajor2Minor2Patch3.
	anotherVersionM1M3P3 := self semanticVersionNumberMajor1Minor3Patch3.
	anotherVersionM1M2P4 := self semanticVersionNumberMajor1Minor2Patch4.
	anotherVersionM1M2P5 := self semanticVersionNumberMajor1Minor2Patch5.
	
	self assert: anotherVersionM1M2P4 < anotherVersionM2M2P3.
	self assert: anotherVersionM1M2P4 < anotherVersionM1M3P3.
	self assert: anotherVersionM1M2P4 < anotherVersionM1M2P5.
	
	self assert: (anotherVersionM1M2P4 < anotherVersionM1M2P4) not.
	self assert: (anotherVersionM1M2P5 < anotherVersionM1M2P4) not.
	self assert: (anotherVersionM1M3P3 < anotherVersionM1M2P4) not.
	self assert: (anotherVersionM2M2P3 < anotherVersionM1M2P4) not.
	
	^ anotherVersionM1M2P4
	
]

{ #category : #'examples - hash' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberHasDifferentWithOtherVersions [
	<gtExample>
	| versionNumber anotherNotEqualVersion1 anotherNotEqualVersion2 anotherNotEqualVersion3 |
	versionNumber := self semanticVersionNumberMajor1Minor2Patch3.
	
	anotherNotEqualVersion1 := self semanticVersionNumberMajor2Minor2Patch3.
	anotherNotEqualVersion2 := self semanticVersionNumberMajor1Minor3Patch3.
	anotherNotEqualVersion3 := self semanticVersionNumberMajor1Minor2Patch4.
	
	self assert: (versionNumber hash ~= anotherNotEqualVersion1 hash).
	self assert: (versionNumber hash ~= anotherNotEqualVersion2 hash).
	self assert: (versionNumber hash ~= anotherNotEqualVersion3 hash).
	
	^ versionNumber
	
]

{ #category : #'examples - hash' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberHasEqualHashWithTheSameVersion [
	<gtExample>
	| versionNumber anotherEqualVersion |
	versionNumber := self semanticVersionNumberMajor1Minor2Patch3.
	anotherEqualVersion := self createSemanticVersionWithMajor: 1 minor: 2 patch: 3. "Ensure a new object"
	
	self assert: versionNumber ~~ anotherEqualVersion.
	self assert: versionNumber hash equals: versionNumber hash.
	self assert: versionNumber hash equals: anotherEqualVersion hash.
	
	^ versionNumber
	
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor2Patch3 [
	<gtExample>
	^ self createSemanticVersionWithMajor: 1 minor: 2 patch: 3.
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor2Patch4 [
	<gtExample>
	^ self createSemanticVersionWithMajor: 1 minor: 2 patch: 4.
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor2Patch5 [
	<gtExample>
	^ self createSemanticVersionWithMajor: 1 minor: 2 patch: 5.
	
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor3Patch3 [
	<gtExample>
	^ self createSemanticVersionWithMajor: 1 minor: 3 patch: 3.
	
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor2Minor2Patch3 [
	<gtExample>
	^ self createSemanticVersionWithMajor: 2 minor: 2 patch: 3.
	
]

{ #category : #'examples - comparison' }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberOtherComparisons [
	<gtExample>
	|  anotherVersionM1M2P4 anotherVersionM1M2P5 |
	anotherVersionM1M2P4 := self semanticVersionNumberMajor1Minor2Patch4.
	anotherVersionM1M2P5 := self semanticVersionNumberMajor1Minor2Patch5.
	
	self assert: anotherVersionM1M2P5 >= anotherVersionM1M2P5.
	self assert: anotherVersionM1M2P5 >= anotherVersionM1M2P4.
	
	self assert: anotherVersionM1M2P5 <= anotherVersionM1M2P5.
	self assert: anotherVersionM1M2P4 < anotherVersionM1M2P5.
	
	self assert: anotherVersionM1M2P5 > anotherVersionM1M2P4.
	self assert: (anotherVersionM1M2P5 > anotherVersionM1M2P5) not.
	
	^ anotherVersionM1M2P4
	
]

{ #category : #'examples - versions' }
GtRlSemanticVersionNumberExamples >> uninitializedSemanticVersionNumber [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber new.
	
	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: 'vnil.nil.nil'.
	self assert: versionNumber versionString equals: 'vnil.nil.nil'.
	self assert: versionNumber major equals: nil.
	self assert: versionNumber minor equals: nil.
	self assert: versionNumber patch equals: nil.
	
	^ versionNumber
	
]
