Extension { #name : #IceDiff }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceDiff >> gtInspectorDiffIn: composite [
	<gtInspectorPresentationOrder:5>
	composite spec 
		display: [ (IceTipDiffPanel on: (IceTipCommitDiffModel on: self)) 
							buildWithSpec;
							yourself ];
		title: 'Diff'
]
