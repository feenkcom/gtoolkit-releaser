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
		thenCollect: #gtAsSemanticVersionNumber.
	^ semanticVersions 
		ifEmpty: [ ^ GtRlSemanticVersionNumber major: 0 minor: 0 patch: 1 ]
		ifNotEmpty: [ 
			self nextSemanticVersionFrom: semanticVersions sorted last ]
]
