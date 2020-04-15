Extension { #name : #IceLibgitRepository }

{ #category : #'*GToolkit-Releaser' }
IceLibgitRepository >> assertRepositoryNotModified: aMessage [
	|changes|
	changes := self workingCopy diffToReferenceCommit treeToShow children asString.
	self 
		assert: [ self isModified not ]
		description: aMessage, '\n', changes.
]
