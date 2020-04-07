Extension { #name : #IceTag }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtAsSemanticVersionNumber [
	|tokens semanticVersionNumber| 
	tokens := self name allButFirst findTokens: '.'. 
	semanticVersionNumber := GtRlSemanticVersionNumber 
		major: tokens first asInteger
		minor: tokens second asInteger
		patch: tokens third asInteger.
	semanticVersionNumber tag: self.
	^ semanticVersionNumber 
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtIsSemanticVersion [
	^ self name matchesRegex: 'v[0-9]+\.[0-9]+\.[0-9]+'
]
