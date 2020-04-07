Extension { #name : #IceRepository }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtSemanticVersionsTags [
	^ self tags select: #gtIsSemanticVersion
]
