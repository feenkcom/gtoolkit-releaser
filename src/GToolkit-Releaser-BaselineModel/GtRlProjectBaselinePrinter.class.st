Class {
	#name : 'GtRlProjectBaselinePrinter',
	#superclass : 'Object',
	#instVars : [
		'project',
		'dependenciesByProjectName'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Builder'
}

{ #category : 'instance creation' }
GtRlProjectBaselinePrinter class >> forProject: aProject [
	^ self new
		project: aProject
]

{ #category : 'accessing' }
GtRlProjectBaselinePrinter >> dependenciesByProjectName: aDictionary [
	dependenciesByProjectName := aDictionary
]

{ #category : 'as yet unclassified' }
GtRlProjectBaselinePrinter >> generateBaselineSource [
	^ String streamContents: [ :aRawStream |
		| baselineStream |
		baselineStream := GtRlBaselinePrinterStream new
			stream: aRawStream.
		self generateBaselineSourceOn: baselineStream ]
]

{ #category : 'as yet unclassified' }
GtRlProjectBaselinePrinter >> generateBaselineSourceOn: aStream [
	aStream 
		methodHeader; 
		commonSpecDo: [  
			project preLoadAction ifNotNil: [ 
				aStream preLoadAction: project preLoadAction ].
			project postLoadAction ifNotNil: [
				aStream postLoadAction: project postLoadAction ].
			
				"project packages do: [ :aPackage |
					aStream 
						packageFor: aPackage name
						withDependencies: aPackage outgoingDependencyNames ]."
			
				project packages do: [ :aPackage |
					aStream 
						packageFor: aPackage name
						withDependencies: aPackage outgoingDependencyNames ]	]
]

{ #category : 'accessing' }
GtRlProjectBaselinePrinter >> project: aProject [
	project := aProject
]
