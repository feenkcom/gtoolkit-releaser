Extension { #name : #IceLibgitRepository }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtRepositoryDirectoryFor: aView [
	<gtView>
	^ (self repositoryDirectory gtItemsFor: aView)
		title: 'Repository directory' translated;
		priority: 35
]
