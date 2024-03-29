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

{ #category : #accessing }
GtRlSystemExamplesExplorer >> allContainedExamples [
	^ GtExampleGroup withAll: (repositoryExplorers flatCollect: [ :each |
		each containedExamples ])
]

{ #category : #accessing }
GtRlSystemExamplesExplorer >> allEditorExamples [
	^ GtExampleGroup withAll: ({
		'Brick-Editor-Examples'.
		'Brick-Examples'.
		'GToolkit-Pharo-Coder'.
		'GToolkit-Pharo-Coder-Examples'
		
		} flatCollect: [ :each |
		each asPackage gtExamplesContained ])
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
		column: 'Name'
			text: [ :repositoryExplorer | repositoryExplorer name ];
		column: 'Examples'
			text: [ :repositoryExplorer | repositoryExplorer containedExamplesCount ]
			width: 100;
		column: 'Test cases'
			text: [ :repositoryExplorer | repositoryExplorer containedTestCasesCount ]
			width: 100
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
