Class {
	#name : #GtRlSystemExamplesExplorer,
	#superclass : #Object,
	#instVars : [
		'rootProject',
		'repositoryExplorersMap',
		'projectExplorersMap'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlSystemExamplesExplorer class >> forProject: aProject [
	^ self new
		initializeForRootProject: aProject
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
GtRlSystemExamplesExplorer >> initialize [
	super initialize.
	repositoryExplorersMap := OrderedDictionary new.
	projectExplorersMap := OrderedDictionary new.
]

{ #category : #initialization }
GtRlSystemExamplesExplorer >> initializeForRootProject: aProject [
	rootProject := aProject.
	repositoryExplorersMap removeAll.
	projectExplorersMap removeAll.
	rootProject withAllRepositories do: [ :aRepository |
		| repositoryExplorer |
		repositoryExplorer := GtRlRepositoryExamplesExplorer forRepository: aRepository.
		repositoryExplorersMap at: aRepository put: repositoryExplorer.
		repositoryExplorer projectExplorers do: [ :aProjectExplorer |
			projectExplorersMap at: aProjectExplorer project put: aProjectExplorer ] ]
]

{ #category : #accessing }
GtRlSystemExamplesExplorer >> repositoryExplorers [
	^ repositoryExplorersMap values
]

{ #category : #accessing }
GtRlSystemExamplesExplorer >> rootProject [
	^ rootProject
]
