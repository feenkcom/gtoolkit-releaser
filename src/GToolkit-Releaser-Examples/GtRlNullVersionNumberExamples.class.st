Class {
	#name : #GtRlNullVersionNumberExamples,
	#superclass : #GtRlVersionNumberExamples,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #examples }
GtRlNullVersionNumberExamples >> nullVersionNumber [
	<gtExample>
	<return: #GtRlNullVersionNumber>
	| versionNumber |
	versionNumber := GtRlNullVersionNumber new.

	self assert: versionNumber isNullVersion.
	self assert: versionNumber versionString equals: 'unknown'.
	self assert: versionNumber description equals: 'unknown'.

	^ versionNumber
]

{ #category : #examples }
GtRlNullVersionNumberExamples >> nullVersionNumberEqualityExample [
	<gtExample>
	<return: #GtRlNullVersionNumber>
	| versionNumber |
	versionNumber := self nullVersionNumber.

	self assert: versionNumber = versionNumber.
	self assert: versionNumber = GtRlNullVersionNumber new.

	^ versionNumber
]
