Class {
	#name : 'GtRlReleaserUsageExamples',
	#superclass : 'Object',
	#traits : 'TGtRlReleaseBuildAssertions',
	#classTraits : 'TGtRlReleaseBuildAssertions classTrait',
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : 'assertions' }
GtRlReleaserUsageExamples >> assertInitialReleasesInAllReleasesInSystemOneFor: aRootRelease [

	self 
		assertReleaseWithBranchStrategy: aRootRelease 
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)  
		withActionsStartingAt: 18
		pushAt: 27.
	self  "ComponentA"
		assertReleaseWithBranchStrategy: aRootRelease childReleases first
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)  
		withActionsNoCompileStartingAt: 1
		pushAt: 22.
	self "ComponentB"
		assertReleaseWithBranchStrategy: aRootRelease childReleases second
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)  
		withActionsStartingAt: 4
		pushAt: 23.
	self "ComponentC"
		assertReleaseWithBranchStrategy: aRootRelease childReleases third
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)
		withActionsNoCompileStartingAt: 8
		pushAt: 24.
	self "ComponentD"
		assertReleaseWithBranchStrategy: aRootRelease childReleases fourth
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)  
		withActionsStartingAt: 14
		pushAt: 26.
	self "ComponentDModuleA"
		assertReleaseWithBranchStrategy: aRootRelease childReleases fourth childReleases first
		withNewVersion: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0)  
		withActionsNoCompileStartingAt: 11
		pushAt: 25.
]

{ #category : 'examples - configs' }
GtRlReleaserUsageExamples >> basicReleaseConfiguration [
	<gtExample>
	| configuration |
	configuration := GtRlReleaseConfiguration new.
	^ configuration
]

{ #category : 'examples - workflows' }
GtRlReleaserUsageExamples >> executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest [
	<gtExample>
	<noTest>
	| baseline project releaseExporter |
	baseline := BaselineOfGtRlBaselineExampleSystemOne.
	project := baseline 
		gtRlProjectWithRepository: 'github://example/SystemOne/src'. 
	releaseExporter := project 
		exporterWithConfiguration: GtRlReleaseConfiguration new.
	releaseExporter releaseCreationActions execute.     "Execute the release"
	releaseExporter releasePostCreationActions execute. "Push changes."
	^ releaseExporter
]

{ #category : 'examples - workflows' }
GtRlReleaserUsageExamples >> executedReleaseWorkflowNoVersionAndDefaultConfigurationFullScriptNoTest [
	<gtExample>
	<noTest>
	| projectBuilder project releaseBuilder release releaseExporter |
	"Create the model for the loading configuration."
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: 'github://example/SystemOne/src'. 
	
	"Create the model for the new release using a release configuration."
	releaseBuilder := GtRlReleaseBuilder new
		configuration: GtRlReleaseConfiguration new.
	release := releaseBuilder buildReleaseForProject: project.
	
	"Create a release exporter containing all release actions."
	releaseExporter := GtRlReleaserExportWorkflow new
		rootProjectRelease: release. 

	"Execute the release."
	releaseExporter releaseCreationActions execute.
	
	"Push local changes."
	releaseExporter releasePostCreationActions execute.
	^ releaseExporter
	
]

{ #category : 'examples - workflows' }
GtRlReleaserUsageExamples >> executedReleaseWorkflowNoVersionRepoAndDefaultConfigurationNoTest [
	<gtExample> 
	<noTest>	
	| release releaseExporter |
	release := self releaseWithNoVersionAndDefaultConfigurationNoTest.
	releaseExporter := GtRlReleaserExportWorkflow new
		rootProjectRelease: release. 
	releaseExporter releaseCreationActions execute.  
	releaseExporter releasePostCreationActions execute.
	^ releaseExporter
]

{ #category : 'examples - releases' }
GtRlReleaserUsageExamples >> releaseWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	| project release releaseBuilder |
	project := self systemOneProjectWithNoVersions.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: self basicReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	self assertInitialReleasesInAllReleasesInSystemOneFor: release.
	^ release
]

{ #category : 'examples - releases' }
GtRlReleaserUsageExamples >> releaseWithNoVersionAndDefaultConfigurationNoTest [
	<gtExample> 
	<noTest>	
	| project release releaseBuilder |
	project := self systemOneProject.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: self basicReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ release
]

{ #category : 'examples - workflows' }
GtRlReleaserUsageExamples >> releaseWorkflowNoVersionRepoAndDefaultConfiguration [
	<gtExample> 
	| release releaseExporter |
	release := self releaseWithNoVersionAndDefaultConfiguration.
	releaseExporter := GtRlReleaserExportWorkflow new
		rootProjectRelease: release. 
	^ releaseExporter
	
	
]

{ #category : 'examples - releases' }
GtRlReleaserUsageExamples >> repositoryReleaseComponentAWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	| release | 
	release := self releaseWithNoVersionAndDefaultConfiguration.
	^ release repositoryRelease childRepositoryReleases detect: [ :aRelease |
		aRelease repository projectName = 'ComponentA' ]
]

{ #category : 'examples - releases' }
GtRlReleaserUsageExamples >> repositoryReleaseWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	| release | 
	release := self releaseWithNoVersionAndDefaultConfiguration.
	^ release repositoryRelease
]

{ #category : 'util' }
GtRlReleaserUsageExamples >> setIcebergRepositoriesWithNoVersionFor: project [
	project withAllRepositories do: [ :aReposiory |
		aReposiory icebergRepository: (GtRlIceMinimalRepository new
			name: aReposiory repositoryName;
			setHead: (GtRlIceMinimalBranch new
				name: 'master');
			addRemote: (GtRlMinimalRemote new
				name: 'origin')) ].
	
	"Fix current issuues caused by projects not being loaded in the image"
	project withDeep: #childProjects do: [ :aProject |
		aProject metacelloToolbox: GtRlMetacelloToolBoxWithSpecs new.
		aProject childProjects do: [ :anotherProject |
			aProject metacelloToolbox addSpecForBaselineClass: anotherProject baselineClass ] ].
]

{ #category : 'examples - actions' }
GtRlReleaserUsageExamples >> systemOneCompileBaselineReleaseAction [
	<gtExample>
	| projectRelease compileBaselineAction |
	projectRelease := self releaseWithNoVersionAndDefaultConfiguration.
	compileBaselineAction := projectRelease releaseActions detect: [ :anAction | 
		anAction class = GtRlCompileBaselineReleaseAction ].
	
	self assert: compileBaselineAction isExecuted not.
	self assert: compileBaselineAction projectRelease equals: projectRelease.
	^ compileBaselineAction
]

{ #category : 'examples - actions' }
GtRlReleaserUsageExamples >> systemOneExportMetadataReleaseAction [
	<gtExample>
	| repositoryRelease exportMetadataAction |
	repositoryRelease := self repositoryReleaseWithNoVersionAndDefaultConfiguration.
	exportMetadataAction := repositoryRelease releaseActions detect: [ :anAction | 
		anAction class = GtRlExportReleaseMetadataAction ].
	
	self assert: exportMetadataAction isExecuted not.
	self assert: exportMetadataAction repositoryRelease equals: repositoryRelease.
	^ exportMetadataAction
]

{ #category : 'examples - projects' }
GtRlReleaserUsageExamples >> systemOneProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: 'github://example/SystemOne/src'. 
	^ project
]

{ #category : 'examples - projects' }
GtRlReleaserUsageExamples >> systemOneProjectWithNoVersions [
	<gtExample>
	| project |
	project := self systemOneProject. 
	"For performing a release we need to attach a valid iceberg repo to the contained projects"
	self setIcebergRepositoriesWithNoVersionFor: project.
	^ project
]

{ #category : 'examples - actions' }
GtRlReleaserUsageExamples >> systemOnePushReleaseAction [
	<gtExample>
	| repositoryRelease pushAction |
	repositoryRelease := self repositoryReleaseWithNoVersionAndDefaultConfiguration.
	pushAction := repositoryRelease releaseActions detect: [ :anAction | 
		anAction class = GtRlPushToOriginReleaseAction ].
	
	self assert: pushAction isExecuted not.
	self assert: pushAction repositoryRelease equals: repositoryRelease.
	^ pushAction
]

{ #category : 'examples - projects' }
GtRlReleaserUsageExamples >> systemThreeProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemThree
		withRepositoryDescription: 'github://example/SystemThree/src'. 
	^ project
]

{ #category : 'examples - projects' }
GtRlReleaserUsageExamples >> systemTwoProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemTwo
		withRepositoryDescription: 'github://example/SystemTwo/src'. 
	^ project
]
