Class {
	#name : #GtRlSemanticVersionExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #accessing }
GtRlSemanticVersionExamples >> firstVersionOfGtoolkit [
	^ GtRlSemanticVersionNumber major: 0 minor: 4 patch: 1
]

{ #category : #accessing }
GtRlSemanticVersionExamples >> firstVersionShouldBeSmallerThanSecond [
	<gtExample>
	self assert: [ self firstVersionOfGtoolkit <= self secondVersionOfGtoolkit  ].
	^ self secondVersionOfGtoolkit 
]

{ #category : #accessing }
GtRlSemanticVersionExamples >> nilShouldBeEqualToNil [
	<gtExample>
	self assert: [ self nilVersion <= self nilVersion  ].
	^ self nilVersion  
]

{ #category : #accessing }
GtRlSemanticVersionExamples >> nilVersion [
	^ GtRlSemanticVersionNumber major: 0 minor: 0 patch: 0
]

{ #category : #accessing }
GtRlSemanticVersionExamples >> secondVersionOfGtoolkit [
	^ GtRlSemanticVersionNumber major: 0 minor: 5 patch: 0
]
