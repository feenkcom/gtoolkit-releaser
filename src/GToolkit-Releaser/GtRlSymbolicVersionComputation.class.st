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
		select: [ :aTag | aTag name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ]
		thenCollect: [ :each | 
			|tokens| 
			tokens := each name findTokens: '.'. 
			GtRlSemanticVersion 
				major: tokens first asInteger
				minor: tokens second asInteger
				patch: tokens third asInteger].
	^ semanticVersions 
		ifEmpty: [ ^ GtRlSemanticVersion major: 0 minor: 0 patch: 1 ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
