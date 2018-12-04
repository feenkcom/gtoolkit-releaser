Extension { #name : #IceGitCommit }

{ #category : #'*GToolkit-Releaser' }
IceGitCommit >> ensureCreateTag: aString [ 
	self repository handleLibgitError: [
		(self repositoryHandle tags) detect: [ :tag | tag = aString ] ifNone:[
		self repositoryHandle
			createTag: aString
			targetId: self libgitCommit id
			force: false].
		^ IceTag
			named: aString
			inRepository: self repository ]
]
