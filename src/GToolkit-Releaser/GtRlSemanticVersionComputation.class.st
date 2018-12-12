Class {
	#name : #GtRlSemanticVersionComputation,
	#superclass : #Object,
	#instVars : [
		'defaultVersionNumber'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlSemanticVersionComputation >> defaultVersionNumber [
	^ defaultVersionNumber
]

{ #category : #accessing }
GtRlSemanticVersionComputation >> defaultVersionNumber: aVersionNumber [
	defaultVersionNumber := aVersionNumber
]

{ #category : #accessing }
GtRlSemanticVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
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
		ifEmpty: [ self defaultVersionNumber ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
