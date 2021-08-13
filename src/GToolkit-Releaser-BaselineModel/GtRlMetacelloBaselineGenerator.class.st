Class {
	#name : 'GtRlMetacelloBaselineGenerator',
	#superclass : 'Object',
	#category : 'GToolkit-Releaser-BaselineModel-Metacello'
}

{ #category : 'baselines' }
GtRlMetacelloBaselineGenerator >> baselineProject [
	self subclassResponsibility 
]

{ #category : 'accessing - dynamic' }
GtRlMetacelloBaselineGenerator >> childProjectsWithRepositoryURL [
	self subclassResponsibility
]

{ #category : 'compiling' }
GtRlMetacelloBaselineGenerator >> compileBaselineMethod [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self compileBaselineWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : 'compiling' }
GtRlMetacelloBaselineGenerator >> compileBaselineWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	
	^ GtPharoCodeModifier current critical: [ toolbox commitBaselineOfMethod ]
]

{ #category : 'api' }
GtRlMetacelloBaselineGenerator >> generateBaselineSource [
	| childProjectsWithRepositoryURL |
	childProjectsWithRepositoryURL := self childProjectsWithRepositoryURL.
 	^ self generateBaselineSourceWithProjectDependencies: childProjectsWithRepositoryURL
]

{ #category : 'private' }
GtRlMetacelloBaselineGenerator >> generateBaselineSourceWithProjectDependencies: projectDependenciesMap [
	| toolbox |
	toolbox := self toolboxForBaselineWithProjectDependencies: projectDependenciesMap.
	^ toolbox methodSpec methodSource
]

{ #category : 'private' }
GtRlMetacelloBaselineGenerator >> toolboxForBaselineWithProjectDependencies: projectDependenciesMap [
	| projectNames toolbox |
	projectNames := projectDependenciesMap collect: #key.

   toolbox := (self baselineProject metacelloToolbox 
	 baselineNamed: self baselineProject baselineClass name)
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
	addBaselineOfSection: #'common'
		requiredProjects: projectNames
	   packages: (self baselineProject packages collect: #name)
	   dependencies: (self baselineProject packages collect: [ :aPackage | 
			aPackage name -> (aPackage requiredNodes collect: #name) ])
	   includes: #()
	   files: #()
	   repositories: projectDependenciesMap
	   preLoadDoIts: #()
	   postLoadDoIts: #()
	   supplyingAnswers: #()
	   groups: #()
	   versionSpecsDo: [ :versionSpec | ].
	
	self assert: [ toolbox methodSpec methodSections size = 1] description: 'Only one section per method is supported'.
	self assert: [ toolbox methodSpec methodSections first attributes = #(#common) ] description: 'Only #common section is supported'.
	self baselineProject preLoadAction ifNotNil: [ :aPreLoadAction |
		toolbox methodSpec methodSections first versionSpec preLoadDoIt: aPreLoadAction ].
	 self baselineProject postLoadAction ifNotNil: [ :aPostLoadAction |
		toolbox methodSpec methodSections first versionSpec postLoadDoIt: aPostLoadAction ].
	
	^ toolbox
]
