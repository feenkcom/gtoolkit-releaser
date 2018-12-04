Class {
	#name : #GtRlSymbolicVersionComputation,
	#superclass : #GtRlVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlSymbolicVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlSymbolicVersionComputation >> releaseVersionForRepository: aRepository [
	| tags semanticVersions |
	tags := aRepository icebergRepository tags. 
	semanticVersions := tags 
		select: #gtIsSemanticVersion
		thenCollect: [ :each | 
			|tokens| 
			tokens := each name allButFirst findTokens: '.'. 
			GtRlSemanticVersion 
				major: tokens first asInteger
				minor: tokens second asInteger
				patch: tokens third asInteger].
	^ semanticVersions 
		ifEmpty: [ ^ GtRlSemanticVersion major: 0 minor: 0 patch: 1 ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
