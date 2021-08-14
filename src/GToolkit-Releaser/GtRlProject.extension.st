Extension { #name : 'GtRlProject' }

{ #category : '*GToolkit-Releaser' }
GtRlProject >> exporterWithConfiguration: aReleaseConfiguration [	
	^ GtRlReleaserExportWorkflow 
		forProject: self withConfiguration: aReleaseConfiguration
]
