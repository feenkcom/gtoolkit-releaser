Class {
	#name : #GtRlExamplesExplorer,
	#superclass : #Object,
	#instVars : [
		'cachedExamples',
		'cachedTestCases'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #accessing }
GtRlExamplesExplorer >> containedExamples [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedExamplesCount [
	^ self containedExamples size
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedTestCases [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlExamplesExplorer >> containedTestCasesCount [
	^ self containedTestCases size
]

{ #category : #accessing }
GtRlExamplesExplorer >> gtClassesFor: aView [ 
	<gtView>
	^ self containedExamples gtClassesFor: aView
]

{ #category : #ui }
GtRlExamplesExplorer >> gtViewExamplesFor: aView [
	<gtView>
	^ self containedExamples gtExamplesFor: aView
]
