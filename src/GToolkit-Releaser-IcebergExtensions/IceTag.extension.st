Extension { #name : 'IceTag' }

{ #category : '*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtAsSemanticVersionNumber [
	| semanticVersionNumber |
	semanticVersionNumber := GtRlSemanticVersionNumber readFromString: self name.
	semanticVersionNumber tag: self.
	^ semanticVersionNumber 
]

{ #category : '*GToolkit-Releaser-IcebergExtensions' }
IceTag >> gtIsSemanticVersion [
	^ self name matchesRegex: 'v[0-9]+\.[0-9]+\.[0-9]+'
]
