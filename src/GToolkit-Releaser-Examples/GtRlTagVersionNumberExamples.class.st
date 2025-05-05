Class {
	#name : #GtRlTagVersionNumberExamples,
	#superclass : #GtRlVersionNumberExamples,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #examples }
GtRlTagVersionNumberExamples >> tagVersionNumber [
	<gtExample>
	<return: #GtRlTagVersionNumber>
	| tagName versionNumber |
	tagName := 'version-alpha'.
	versionNumber := GtRlTagVersionNumber new tagName: tagName.

	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: tagName.
	self assert: versionNumber tagName equals: tagName.
	self assert: versionNumber versionString equals: tagName.

	^ versionNumber
]

{ #category : #examples }
GtRlTagVersionNumberExamples >> tagVersionNumberEqualityExamples [
	<gtExample>
	<return: #GtRlTagVersionNumber>
	| tagName versionNumber anotherEqualVersion anotherNotEqualVersion |
	tagName := 'version-alpha'.
	versionNumber := GtRlTagVersionNumber new tagName: tagName.
	anotherEqualVersion := GtRlTagVersionNumber new tagName: tagName.
	anotherNotEqualVersion := GtRlTagVersionNumber new tagName: 'version-beta'.

	self assert: versionNumber = versionNumber.
	self assert: versionNumber = anotherEqualVersion.
	self assert: (versionNumber = anotherNotEqualVersion) not.

	^ versionNumber
]

{ #category : #examples }
GtRlTagVersionNumberExamples >> uninitializedTagVersionNumber [
	<gtExample>
	<return: #GtRlTagVersionNumber>
	| versionNumber |
	versionNumber := GtRlTagVersionNumber new.

	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: nil.
	self assert: versionNumber tagName equals: nil.
	self assert: versionNumber versionString equals: nil.

	^ versionNumber
]
