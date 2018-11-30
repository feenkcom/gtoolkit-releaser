Class {
	#name : #FkRlSymbolicVersionComputation,
	#superclass : #FkRlVersionComputation,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlSymbolicVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	self subclassResponsibility
]

{ #category : #accessing }
FkRlSymbolicVersionComputation >> releaseVersionForRepository: aRepository [
	| tags semanticVersions |
	tags := aRepository icebergRepository tags. 
	semanticVersions := tags 
		select: [ :aTag | aTag name matchesRegex: '[0-9]+\.[0-9]+\.[0-9]+' ]
		thenCollect: [ :each | 
			|tokens| 
			tokens := each name findTokens: '.'. 
			FkRlSemanticVersion 
				major: tokens first asInteger
				minor: tokens second asInteger
				patch: tokens third asInteger].
	^ semanticVersions 
		ifEmpty: [ ^ FkRlSemanticVersion major: 0 minor: 0 patch: 1 ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
