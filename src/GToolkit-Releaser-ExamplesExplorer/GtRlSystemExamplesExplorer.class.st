Class {
	#name : #GtRlSystemExamplesExplorer,
	#superclass : #Object,
	#instVars : [
		'rootProject',
		'repositoryExplorers'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlSystemExamplesExplorer class >> forProject: aProject [
	^ self new
		initializeForRootProject: aProject
]

{ #category : #converting }
GtRlSystemExamplesExplorer >> asPreviewElement [
	"Used by ${method:GtSpotterStart>>#gtSpotterForToolsFor:}$"
	^ GtInspector newOn: self
]

{ #category : #ui }
GtRlSystemExamplesExplorer >> gtDisplayOn: stream [
	stream nextPutAll: 'Examples Explorer'
]

{ #category : #ui }
GtRlSystemExamplesExplorer >> gtViewRepositoriesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories' translated;
		items: [ self repositoryExplorers ];
		column: 'Name' format: [ :repositoryExplorer | repositoryExplorer name ];
		column: 'Examples' format: [ :repositoryExplorer | repositoryExplorer containedExamplesCount ] width: 100 ;
		column: 'Test cases' format: [ :repositoryExplorer | repositoryExplorer containedTestCasesCount ]  width: 100
]

{ #category : #initialization }
GtRlSystemExamplesExplorer >> initializeForRootProject: aProject [
	rootProject := aProject.
	repositoryExplorers := rootProject withAllRepositories collect: [ :aRepository |
		GtRlRepositoryExamplesExplorer forRepository: aRepository ]
]

{ #category : #accessing }
GtRlSystemExamplesExplorer >> repositoryExplorers [
	^ repositoryExplorers
]

{ #category : #accessing }
GtRlSystemExamplesExplorer >> rootProject [
	^ rootProject
]
