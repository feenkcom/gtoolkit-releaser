Class {
	#name : #GtRlRepositoryExamplesExplorer,
	#superclass : #GtRlExamplesExplorer,
	#instVars : [
		'repository',
		'projectExplorers'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlRepositoryExamplesExplorer class >> forRepository: aRepository [
	^ self new
		initializeForRepository: aRepository
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> containedExamples [
	^ cachedExamples ifNil: [
		| currentExamples |
		currentExamples := OrderedCollection new.
		self projectExplorers do: [ :aProjectExplorer | 
			currentExamples addAll: aProjectExplorer containedExamples ].
		cachedExamples := GtExampleGroup withAll: currentExamples ]
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> containedTestCases [
	^ cachedTestCases ifNil: [
		cachedTestCases := OrderedCollection new.
		self projectExplorers do: [ :aProjectExplorer | 
			cachedTestCases addAll: aProjectExplorer containedTestCases ].
		cachedTestCases ]
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> gtPackagesFor: aView [ 
	<gtView>
	^ self containedExamples gtPackagesFor: aView
]

{ #category : #ui }
GtRlRepositoryExamplesExplorer >> gtViewProjectsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Projects' translated;
		items: [ self projectExplorers ];
		column: 'Name' format: [ :projectExplorer | projectExplorer name ];
		column: 'Examples' 
			format: [ :projectExplorer | projectExplorer containedExamplesCount ] 
			width: 100;
		column: 'Test cases' 
			format: [ :projectExplorer | projectExplorer containedTestCasesCount ] 
			width: 100
		
]

{ #category : #initialization }
GtRlRepositoryExamplesExplorer >> initializeForRepository: aRepository [
	repository := aRepository.
	projectExplorers := aRepository projects collect: [ :aProject |
		GtRlProjectExamplesExplorer forProject: aProject ]
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> name [
	^ self repository repositoryName
]

{ #category : #printing }
GtRlRepositoryExamplesExplorer >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> projectExplorers [
	^ projectExplorers
]

{ #category : #accessing }
GtRlRepositoryExamplesExplorer >> repository [
	^ repository
]
