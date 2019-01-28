Extension { #name : #IceMerge }

{ #category : #'*GToolkit-Releaser-IcebergExtensions' }
IceMerge >> gtInspectorMergeWindowIn: composite [
	<gtInspectorPresentationOrder:20>
	composite morph 
		title: 'Merge';
		display: [    
			|mergeMorph|
			 mergeMorph := (IceTipMergeMorph forMerger: self).
		    mergeMorph
		        fromDescription: self sourceDescription;
		        toDescription: self targetDescription.
			 mergeMorph ]
]
