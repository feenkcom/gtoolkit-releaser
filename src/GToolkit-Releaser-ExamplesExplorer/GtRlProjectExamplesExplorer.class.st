Class {
	#name : #GtRlProjectExamplesExplorer,
	#superclass : #GtRlExamplesExplorer,
	#instVars : [
		'project'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #'instance creation' }
GtRlProjectExamplesExplorer class >> forProject: aProject [
	^ self new
		initializeForProject: aProject
]

{ #category : #accessing }
GtRlProjectExamplesExplorer >> containedExamples [
	^ cachedExamples ifNil: [
		| currentExamples |
		currentExamples := OrderedCollection new.
		self containedRPackagesDo: [ :aRPackage | 
			currentExamples addAll: aRPackage gtExamplesContained ].
		cachedExamples := GtExampleGroup withAll: currentExamples ]
]

{ #category : #enumerating }
GtRlProjectExamplesExplorer >> containedRPackagesDo: aBloc [
	self project packages do: [ :aReleaserPackage |
		(RPackageOrganizer default 
			packageNamed: aReleaserPackage name 
			ifAbsent: [nil]) ifNotNil: [ :aRPackage | aBloc value: aRPackage ] ]
]

{ #category : #accessing }
GtRlProjectExamplesExplorer >> containedTestCases [
	^ cachedTestCases ifNil: [
		cachedTestCases := OrderedCollection new.
		self containedRPackagesDo: [ :aRPackage | 
			cachedTestCases addAll: ((aRPackage classes select: #isTestCase) flatCollect: [ :testClass | 
				testClass buildSuiteFromAllSelectors tests ]) ].
		cachedTestCases ]
]

{ #category : #initialization }
GtRlProjectExamplesExplorer >> initializeForProject: aProject [
	project := aProject
]

{ #category : #accessing }
GtRlProjectExamplesExplorer >> name [
	^ self project name
]

{ #category : #printing }
GtRlProjectExamplesExplorer >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self project name;
		nextPut: $)
]

{ #category : #accessing }
GtRlProjectExamplesExplorer >> project [
	^ project
]
