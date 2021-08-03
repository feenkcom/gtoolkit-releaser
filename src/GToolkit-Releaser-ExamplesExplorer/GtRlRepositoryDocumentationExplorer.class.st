Class {
	#name : 'GtRlRepositoryDocumentationExplorer',
	#superclass : 'GtRlDocumentationExplorer',
	#instVars : [
		'repository'
	],
	#category : 'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : 'instance creation' }
GtRlRepositoryDocumentationExplorer class >> forRepository: aRepository [
	^ self new
		initializeForRepository: aRepository
]

{ #category : 'initialization' }
GtRlRepositoryDocumentationExplorer >> initializeForRepository: aRepository [
	repository := aRepository.
	aRepository projects do: [ :aChildProject |
		aChildProject baselineClass hasComment ifTrue: [ 
			self explanationClasses add: aChildProject baselineClass ].
		
		aChildProject containedRPackagesDo: [ :aRPackage |
			| packageClasses |
			packageClasses := aRPackage classes.
			self tutorialClasses addAll: (packageClasses select: [ :aClass | 
				(aClass name endsWith: 'Tutorial') and: [aClass hasComment ] ]).
			self howToGuideClasses addAll: (packageClasses select: [ :aClass | 
				(aClass name endsWith: 'HowToGuide') and: [aClass hasComment ] ]).
			self explanationClasses addAll: (packageClasses select: [ :aClass | 
				(aClass name endsWith: 'Explanation') and: [aClass hasComment ] ]).
			self exampleClasses addAll: (packageClasses select: [ :aClass | 
				(aClass name endsWith: 'Examples') and: [aClass hasComment ] ]) ] ]
	
]

{ #category : 'accessing' }
GtRlRepositoryDocumentationExplorer >> repository [ 	
	^ repository
]
