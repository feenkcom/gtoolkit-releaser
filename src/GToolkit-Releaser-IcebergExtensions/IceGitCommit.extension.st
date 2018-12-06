Extension { #name : #IceGitCommit }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceGitCommit >> gtFileSystemItemsFor: aView [
	<gtView>
	^ (self fileSystem gtItemsFor: aView)
		title: 'File system' translated;
		priority: 70
]
