Class {
	#name : #FkRlVersionComputation,
	#superclass : #Object,
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	self subclassResponsibility
]

{ #category : #accessing }
FkRlVersionComputation >> nextVersionForRepository: aRepository [
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
