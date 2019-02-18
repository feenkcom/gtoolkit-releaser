Class {
	#name : #GtRlSemanticVersionNumberExamples,
	#superclass : #GtRlVersionNumberExamples,
	#category : #'GToolkit-Releaser-Examples'
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

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumber [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 1 minor: 2 patch: 3.
	self assertSemanticVersion: versionNumber withMajor: 1 minor: 2 patch: 3.
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberComparisonExample [
	<gtExample>
	| versionNumber anotherEqualVersion anotherNotEqualVersion1 anotherNotEqualVersion2 anotherNotEqualVersion3 |
	versionNumber := self semanticVersionNumber.
	anotherEqualVersion := GtRlSemanticVersionNumber new 
		initializeMajor: 1 minor: 2 patch: 3. "Ensure a new object"
	
	anotherNotEqualVersion1 := self semanticVersionNumberMajor2Minor2Patch3.
	anotherNotEqualVersion2 := self semanticVersionNumberMajor1Minor3Patch3.
	anotherNotEqualVersion3 := self semanticVersionNumberMajor1Minor2Patch4.
	
	self assert: versionNumber = versionNumber.
	self assert: versionNumber = anotherEqualVersion.
	self assert: (versionNumber = anotherNotEqualVersion1) not.
	self assert: (versionNumber = anotherNotEqualVersion2) not.
	self assert: (versionNumber = anotherNotEqualVersion3) not.
	
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberEqualityExample [
	<gtExample>
	| versionNumber anotherEqualVersion anotherNotEqualVersion1 anotherNotEqualVersion2 anotherNotEqualVersion3 |
	versionNumber := self semanticVersionNumber.
	anotherEqualVersion := GtRlSemanticVersionNumber major: 1 minor: 2 patch: 3. "Ensure a new object"
	
	anotherNotEqualVersion1 := self semanticVersionNumberMajor2Minor2Patch3.
	anotherNotEqualVersion2 := self semanticVersionNumberMajor1Minor3Patch3.
	anotherNotEqualVersion3 := self semanticVersionNumberMajor1Minor2Patch4.
	
	self assert: versionNumber = versionNumber.
	self assert: versionNumber = anotherEqualVersion.
	self assert: (versionNumber = anotherNotEqualVersion1) not.
	self assert: (versionNumber = anotherNotEqualVersion2) not.
	self assert: (versionNumber = anotherNotEqualVersion3) not.
	
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberGreaterThenEqualityExample [
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

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor2Patch4 [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 1 minor: 2 patch: 4.
	self assertSemanticVersion: versionNumber withMajor: 1 minor: 2 patch: 4.
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor2Patch5 [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 1 minor: 2 patch: 5.
	self assertSemanticVersion: versionNumber withMajor: 1 minor: 2 patch: 5.
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor1Minor3Patch3 [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 1 minor: 3 patch: 3.
	self assertSemanticVersion: versionNumber withMajor: 1 minor: 3 patch: 3.
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberMajor2Minor2Patch3 [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlSemanticVersionNumber major: 2 minor: 2 patch: 3.
	self assertSemanticVersion: versionNumber withMajor: 2 minor: 2 patch: 3.
	^ versionNumber
	
]

{ #category : #examples }
GtRlSemanticVersionNumberExamples >> semanticVersionNumberOtherEqualityExample [
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

{ #category : #examples }
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
