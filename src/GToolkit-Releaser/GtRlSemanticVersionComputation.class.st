"
I compute the next semantic version number for a repository. My subclasses decide which part of the version number is incremented.

I allow a default semantic version number in case a previous version number is not found in the repository. If that is not given, a {{gtClass:GtRlNullVersionNumber}} is used.
Subclasses need to override ${method:GtRlSemanticVersionComputation>>#nextSemanticVersionFrom:)$ to provide the logic for computing the next semantic version number.


"
Class {
	#name : #GtRlSemanticVersionComputation,
	#superclass : #Object,
	#instVars : [
		'defaultVersionNumber'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlSemanticVersionComputation >> defaultVersionNumber [
	^ defaultVersionNumber
]

{ #category : #accessing }
GtRlSemanticVersionComputation >> defaultVersionNumber: aVersionNumber [
	self 
		assert: [ aVersionNumber notNil ] 
		description: 'Version numbers should not be nil. A null object should be used instead'.
	defaultVersionNumber := aVersionNumber
]

{ #category : #accessing }
GtRlSemanticVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	"I compute the next symbolic version number based on the given symbolic version.
	Subclasses should return a new object as semantic version objects are immutable."
	self subclassResponsibility
]

{ #category : #accessing }
GtRlSemanticVersionComputation >> nextVersionNumberForRepository: aRepository [
	| tags semanticVersions |
	tags := aRepository icebergRepository tags. 
	semanticVersions := tags 
		select: #gtIsSemanticVersion
		thenCollect: #gtAsSemanticVersionNumber.
	^ semanticVersions 
		ifEmpty: [ self defaultVersionNumber ifNil: [ 
				GtRlNullVersionNumber new ] ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
