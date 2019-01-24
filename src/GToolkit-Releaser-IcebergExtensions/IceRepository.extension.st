Extension { #name : #IceRepository }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtActionFetchFor: anAction [
	<gtAction>
	^ anAction button
		label: 'Fetch';
		action: [ 
			(IceTipRepositoryModel on: self) fetch ]
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtLocalBranchesFor: aView [
	<gtView>
	^ aView list  
		title: 'Branches' translated;
		priority: 20;
		items: [ self localBranches ];
		itemFormat: #name
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtPackagesFor: aView [
	<gtView>
	^ aView columnedList 
		priority: 15;
		title: 'Packages' translated;
		items: [ (IceSortingStrategy new first: #modified) sort: self workingCopy packages ];
		column: 'Name' item: #gtPackageDescription;
		column: 'Status' item: #gtPackageStatus
		
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtRemoteBranchesFor: aView [
	<gtView>
	^ aView list  
		title: 'Remotes' translated;
		priority: 24;
		items: [ self remoteTrackedBranches ];
		itemFormat: #name
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtSemanticVersionsTags [
	^ self tags select: #gtIsSemanticVersion
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtTagsFor: aView [
	<gtView>
	^ aView list 
		title: 'Tags' translated;
		priority: 30;
		items: [ self tags ];
		itemFormat: [ :anIceTag |
			anIceTag name, ' [', (anIceTag commit id first: 7), ']' ]
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtViewIncomingCommitsFor: aView [
	<gtView>
	| incomingCommits |
	incomingCommits := GtRlIceCommitsGroup forCommits: self incomingCommits.
	^ incomingCommits commits
		ifEmpty: [ aView ]
		ifNotEmpty: [ 
			(incomingCommits gtViewCommitsListFor: aView)
				title: 'Incoming commits';
				priority: 10 ]
]

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceRepository >> gtViewOutgoingCommitsFor: aView [
	<gtView>
	| outgoingCommits |
	outgoingCommits := GtRlIceCommitsGroup forCommits: self outgoingCommits.
	^ outgoingCommits commits
		ifEmpty: [ aView ]
		ifNotEmpty: [ 
			(outgoingCommits gtViewCommitsListFor: aView)
				title: 'Outgoing commits';
				priority: 12 ]
]
