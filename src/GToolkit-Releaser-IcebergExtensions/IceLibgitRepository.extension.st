Extension { #name : #IceLibgitRepository }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtLocalBranchesFor: aView [
	<gtView>
	^ aView list  
		title: 'Branches' translated;
		priority: 20;
		items: [ self localBranches ];
		itemFormat: #name
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtPackagesFor: aView [
	<gtView>
	^ aView columnedList 
		priority: 15;
		title: 'Packages' translated;
		items: [ (IceSortingStrategy new first: #modified) sort: self workingCopy packages ];
		column: 'Name' item: #gtPackageDescription;
		column: 'Status' item: #gtPackageStatus
		
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtRemoteBranchesFor: aView [
	<gtView>
	^ aView list  
		title: 'Remotes' translated;
		priority: 24;
		items: [ self remoteTrackedBranches ];
		itemFormat: #name
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceLibgitRepository >> gtTagsFor: aView [
	<gtView>
	^ aView list 
		title: 'Tags' translated;
		items: [ self tags ];
		itemFormat: [ :anIceTag |
			anIceTag name, ' [', (anIceTag commit id first: 7), ']' ]
]
