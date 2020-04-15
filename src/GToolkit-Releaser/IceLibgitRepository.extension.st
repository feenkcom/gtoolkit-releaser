Extension { #name : #IceLibgitRepository }

{ #category : #'*GToolkit-Releaser' }
IceLibgitRepository >> assertRepositoryNotModified: aMessage [
	|changes|
	changes := ((self workingCopy diffToReferenceCommit treeToShow) withDeep: #children collect: #description)  asString.
	self 
		assert: [ self isModified not ]
		description: aMessage, OSPlatform current lineEnding, changes.
]
