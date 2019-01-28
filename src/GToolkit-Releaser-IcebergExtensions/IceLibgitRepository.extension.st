Extension { #name : #IceLibgitRepository }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtActionFetchFor: anAction [
	<gtAction>
	self isMissing ifTrue: [ ^ anAction ].
	^ anAction button
		label: 'Fetch';
		action: [ 
			(IceTipRepositoryModel on: self) fetch ]
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtLocalBranchesFor: aView [
	self isMissing ifTrue: [ ^ aView ].
	^ super gtLocalBranchesFor: aView
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtRemoteBranchesFor: aView [
	self isMissing ifTrue: [ ^ aView ].
	^ super gtRemoteBranchesFor: aView
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtRepositoryDirectoryFor: aView [
	<gtView>
	self isMissing ifTrue: [ ^ aView ].
	^ (self repositoryDirectory gtItemsFor: aView)
		title: 'Repository directory' translated;
		priority: 35
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtTagsFor: aView [
	self isMissing ifTrue: [ ^ aView ].
	^ super gtTagsFor: aView
]
