Extension { #name : 'ByteString' }

{ #category : '*GToolkit-Releaser-Jenkins' }
ByteString >> asGtRlSemanticVersionNumber [
	|tokens withoutPrefix|
	withoutPrefix := self withoutPrefix: 'v' .
	self assert: self size - 1 equals: withoutPrefix size.
	tokens := withoutPrefix findTokens: '.'.
	^ GtRlSemanticVersionNumber 
		major: (tokens at:1) asInteger 
		minor: (tokens at:2) asInteger 
		patch: (tokens at:3) asInteger
]
