Class {
	#name : #GtRlSystemOneReleaseExamples,
	#superclass : #GtRlSystemOneModelExamples,
	#instVars : [
		'repositoryReleaseComponentB'
	],
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
GtRlSystemOneReleaseExamples >> assertStandaloneRepositoryRelease: aRelease [
	self assert: aRelease isPassiveRelease.
	self assert: aRelease releaseActions isEmpty.
	self assert: aRelease projectReleases isEmpty.
	self assert: aRelease version isNullVersion.
	self assert: aRelease releaseStrategy isNullReleaseStrategy.
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentA [
	<gtExample>
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new
		project: self projectComponentA.
	repositoryRelease := self repositoryReleaseComponentA.
	repositoryRelease addProjectRelease: projectRelease.
	
	self assert: projectRelease repositoryRelease equals: repositoryRelease.
	self assert: projectRelease project repository == repositoryRelease repository.
	self assert: repositoryRelease projectReleases asArray equals: { projectRelease }.
	
	^ projectRelease
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentBMain [
	<gtExample>
	| projectReleaseBMain projectReleaseBUtil repositoryRelease |
	projectReleaseBUtil := self projectReleaseComponentBUtil.
	projectReleaseBMain := GtRlProjectRelease new
		project: self projectComponentBMain.
	repositoryRelease := self repositoryReleaseComponentB.	
	repositoryRelease addProjectRelease: projectReleaseBMain.
	projectReleaseBMain
		addChildRelease: projectReleaseBUtil.
	
	self assert: projectReleaseBUtil repositoryRelease == repositoryRelease.
	self assert: projectReleaseBUtil project repository == repositoryRelease repository.
	self assert: repositoryRelease projectReleases asArray equals: { projectReleaseBUtil . projectReleaseBMain }.
	
	self assert: repositoryRelease childRepositoryReleases isEmpty.
	self assert: projectReleaseBMain childReleases asArray equals: { projectReleaseBUtil }.
	self assert: projectReleaseBUtil project == projectReleaseBMain childReleases first project.
	
	^ projectReleaseBMain
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentBUtil [
	<gtExample>
	| projectReleaseBUtil repositoryRelease |
	projectReleaseBUtil := GtRlProjectRelease new
		project: self projectComponentBUtil.
	repositoryRelease := self repositoryReleaseComponentB.	
	repositoryRelease addProjectRelease: projectReleaseBUtil.
	
	self assert: projectReleaseBUtil repositoryRelease == repositoryRelease.
	self assert: projectReleaseBUtil project repository == repositoryRelease repository.
	self assert: repositoryRelease projectReleases asArray equals: { projectReleaseBUtil }.
		
	^ projectReleaseBUtil
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentC [
	<gtExample>
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new
		project: self projectComponentC.
	repositoryRelease := self repositoryReleaseComponentC.
	repositoryRelease addProjectRelease: projectRelease.
	
	self assert: projectRelease repositoryRelease equals: repositoryRelease.
	self assert: repositoryRelease projectReleases asArray equals: { projectRelease }.
	
	^ projectRelease
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentD [
	<gtExample>
	| projectDRelease projectDModuleARelease repositoryRelease |
	projectDRelease := GtRlProjectRelease new
		project: self projectComponentD.
	projectDModuleARelease := self projectReleaseComponentDModuleA.
	projectDRelease
		addChildRelease: projectDModuleARelease.
	repositoryRelease := self repositoryReleaseComponentD.
	repositoryRelease addProjectRelease: projectDRelease.
	
	self assert: projectDRelease repositoryRelease equals: repositoryRelease.
	self assert: projectDRelease project repository == repositoryRelease repository.
	self assert: repositoryRelease projectReleases asArray equals: { projectDRelease }.
	self assert: repositoryRelease childRepositoryReleases asArray equals: { projectDModuleARelease repositoryRelease }.
	self assert: projectDRelease childReleases asArray equals: { projectDModuleARelease }.
	self assert: projectDModuleARelease project == projectDRelease childReleases first project.
	
	^ projectDRelease
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseComponentDModuleA [
	<gtExample>
	| projectRelease repositoryRelease |
	projectRelease := GtRlProjectRelease new
		project: self projectComponentDModuleA.
	repositoryRelease := self repositoryReleaseComponentDModuleA.
	repositoryRelease addProjectRelease: projectRelease.
	
	self assert: projectRelease repositoryRelease equals: repositoryRelease.
	self assert: projectRelease project repository == repositoryRelease repository.
	self assert: repositoryRelease projectReleases asArray equals: { projectRelease }.
	
	^ projectRelease
]

{ #category : #'examples - projects' }
GtRlSystemOneReleaseExamples >> projectReleaseSystem [
	<gtExample>
	| systemRelease repositoryRelease projectReleaseComponentA projectReleaseComponentB projectReleaseComponentC projectReleaseComponentD |
	systemRelease := GtRlProjectRelease new
		project: self projectSystem.
	projectReleaseComponentA := self projectReleaseComponentA.
	projectReleaseComponentB := self projectReleaseComponentBMain.
	projectReleaseComponentC := self projectReleaseComponentC.
	projectReleaseComponentD := self projectReleaseComponentD.
	systemRelease 
		addChildRelease: projectReleaseComponentA;
		addChildRelease: projectReleaseComponentB;
		addChildRelease: projectReleaseComponentC;
		addChildRelease: projectReleaseComponentD.
	repositoryRelease := self repositoryReleaseSystem.
	repositoryRelease addProjectRelease: systemRelease.
	
	self 
		assert: repositoryRelease childRepositoryReleases asArray 
		equals: { 
			projectReleaseComponentA repositoryRelease . 
			projectReleaseComponentB repositoryRelease . 
			projectReleaseComponentC repositoryRelease . 
			projectReleaseComponentD repositoryRelease }.
	self assert: projectReleaseComponentA repositoryRelease parentRepositoryReleases asArray equals: {repositoryRelease}.
	
	^ systemRelease
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentA [
	<gtExample>
	| repository release |
	repository := self repositoryComponentA.
	release := GtRlRepositoryRelease new
		repository: repository.
		
	self assert: release repository equals: repository.
	self assert: release urlWithReleaseVersion asString equals: 'github://example/ComponentA:unknown/src'.
	self assertStandaloneRepositoryRelease: release.
		
	^ release
	
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentB [
	<gtExample>
	^ repositoryReleaseComponentB ifNil: [
		| repository release |
		repository := self repositoryComponentB.
		release := GtRlRepositoryRelease new
			repository: repository.
	
		self assert: release repository equals: repository.
		self assert: release urlWithReleaseVersion asString equals: 'github://example/ComponentB:unknown/src'.
		self assertStandaloneRepositoryRelease: release.
		
		^ repositoryReleaseComponentB := release ]
	
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentC [
	<gtExample>
	| repository release |
	repository := self repositoryComponentC.
	release := GtRlRepositoryRelease new
		repository: repository.
	
	self assert: release repository equals: repository.
	self assert: release urlWithReleaseVersion asString equals: 'github://example/ComponentC:unknown/src'.
	self assertStandaloneRepositoryRelease: release.
		
	^ release
	
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentD [
	<gtExample>
	| repository release |
	repository := self repositoryComponentD.
	release := GtRlRepositoryRelease new
		repository: repository.
	
	self assert: release repository equals: repository.
	self assert: release urlWithReleaseVersion asString equals: 'github://example/ComponentD:unknown/src'.
	self assertStandaloneRepositoryRelease: release.
		
	^ release
	
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseComponentDModuleA [
	<gtExample>
	| repository release |
	repository := self repositoryComponentDModuleA.
	release := GtRlRepositoryRelease new
		repository: repository.
	
	self assert: release repository equals: repository.
	self assert: release urlWithReleaseVersion asString equals: 'github://example/ComponentDModuleA:unknown/src'.
	self assertStandaloneRepositoryRelease: release.
		
	^ release
	
]

{ #category : #'examples - repositories' }
GtRlSystemOneReleaseExamples >> repositoryReleaseSystem [
	<gtExample>
	| repository release |
	repository := self repositorySystem.
	release := GtRlRepositoryRelease new
		repository: repository.
	
	self assert: release repository equals: repository.
	self assert: release urlWithReleaseVersion asString equals: 'github://example/SystemOne:unknown/src'.
	self assertStandaloneRepositoryRelease: release.
		
	^ release
	
]
