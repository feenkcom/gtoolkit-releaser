Class {
	#name : #GtRlSystemDocumentationExplorer,
	#superclass : #GtRlDocumentationExplorer,
	#instVars : [
		'rootProject',
		'repositoryExplorers'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlSystemDocumentationExplorer class >> forProject: aProject [
	^ self new
		initializeForRootProject: aProject
]

{ #category : #ui }
GtRlSystemDocumentationExplorer >> gtViewPerProjectsListFor: aView [
	<gtView>
	^ aView list
		title: 'Per-projects' translated;
		priority: 50;
		items: [ repositoryExplorers ];
		itemFormat: [ :aRepositoryExplorer | aRepositoryExplorer repository repositoryName ]
]

{ #category : #initialization }
GtRlSystemDocumentationExplorer >> initializeForRootProject: aProject [
	rootProject := aProject.
	repositoryExplorers := rootProject withAllRepositories collect: [ :aRepository |
		| repositoryDocumentation |
		repositoryDocumentation := GtRlRepositoryDocumentationExplorer forRepository: aRepository.
		self tutorialClasses addAll: repositoryDocumentation tutorialClasses.
		self exampleClasses addAll: repositoryDocumentation exampleClasses.
		self explanationClasses addAll: repositoryDocumentation explanationClasses.
		self howToGuideClasses addAll: repositoryDocumentation howToGuideClasses.
		repositoryDocumentation ] 
]

{ #category : #accessing }
GtRlSystemDocumentationExplorer >> rootProject [
	^ rootProject
]
