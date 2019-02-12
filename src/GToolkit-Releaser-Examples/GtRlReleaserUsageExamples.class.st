"
!GtReleaser Wiki

This is the GtReleser wiki, a live, interactive document living and evolving in the image. It contains details about GtReleaser, like its intent, usage, internal structure, as well rationale about various design decisions. 

!!Overview
GtReleaser allows the creation of release versions for applications that use Metacello baselines to specify their loading configuration (what packages to load, their loading order and their dependencies). GtReleaser supports projects that use deeply nested baselines spread across many git repositories with a mix of baselines with fix dependencies and dependencies to latest versions. 

GtReleaser aims to be easy to debug. Several design decision, like computing all actions before executing a release and using separate models for releases and dependencies go in that direction. GtReleaser also uses extensively inspector views to help expose implementation details.

Currently GtRelease only provides support for generating new releases. However, in the context of Glamorous Toolkit, the goal is to extend it with support for loading baselines, not only generating them. Several other tools for working with a project (like running all tests in a project, or commiting changes to multiple repositories) could be based on GtReleaser.

In short, to create a new release a user has to: 
 - ensure that all the code of the application that needs to be released is loaded in the current image;
 - create a ${class:GtRlReleaseConfiguration}$ configuration controlling various aspects of the release process;
 - run the release exporter to create new Metacello baselines that use fix versions to load dependencies. 

Releases can be done manually from the image using the inspector as a user interface, or by relying on a command line handler.
The next sections introduce the main concepts of GtReleaser through examples. They show how to create new releases programatically on an example system using the inspector.

!!!Example system 
To exemplify releaser in more details we use an example system that simulates a real system having multiple baselines spread across multiple repositories. The main baseline of this system is given by the class ${class:BaselineOfGtRlBaselineExampleSystemOne}$. In total this project uses seven baselines with two levels of dependencies. The picture below shows the dependencies between these baselines.

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}$

Another way to look at these baselines is to group them based on the repoitory containing them, as shown below. In this case we have six distinct repositories. One repository contains two baselines and the others a single baseline. For this example system, all repositries are github repositories belonging to the user *example*.

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtRepoMapFor:|noCode|previewHeight=300}$ 

!!Default configuration
Let's assume that we just started developing this system and we need to create the first release. As a first example, we use a standard configuration with default options. We can obtain it by instantiating the class ${class:GtRlReleaseConfiguration}$.

${example:GtRlReleaserUsageExamples>>#basicReleaseConfiguration|previewShow=#gtDefaultOptionsFor:|previewHeight=200|previewExpanded}$

The main available options are:
	- *Release strategy*: The strategy for creating the actual release. By default a new release is created on a dedicated release branch. Release strategies are subclasses of ${class:GtRlReleaseStrategy}$:
	- *Release branch*: The dedicated release branch on which the release will be done, in case the strategy uses a release branch;
	- *Version number*: The default version number in case there is no version already present in the repository;
	- *Version computation*: The strategy for computing the next version number in case a version already exists;
	- *Force release*: Whether or not to force a new release if there are no changes in the repository.
	
By default a new release is created on the =='release'==  branch, starting at the semantic version =='v0.1.0'==  and incrementing the patch number. In case there are no new changes since the previous release a new release is not created. Several of these options can be configured per each individual repository. 

!!Creating the initial release in a nutshell
To perform a relese we:
- create a project object modeling the loading configuration of a system; we create it starting from a Metacello baseline;
- create a release exporter for the project based on a release configuration;
- perform the release using the exporter.

The method below shows the code for creating the first release for our example system using the default configuration. 
${example:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest}$

Running the exporter creates a new branch named 'release' in all project repositories, tags the latest commit in those branches with the tag =='v0.1.0'==, and updates the project baseliens to load the new tag instead of the latest version. The figure below shows the dependencies between projects in the new release. 
${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewShow=#gtProjectMapFor:|previewHeight=250|noCode}$

!!Creating the initial release step-by-step
Next we go in more details through the steps performed by GtReleaser when creating a release. This can prove useful when debugging problems or when looking to understand how GtReleaser works.

GtReleaser relies on two distinct models: one for capturing dependencies between baselines and another for generating the new release based on a given configuration. Before a new release is made the user needs to create the first model, capturing dependencies between baselines. This is an instance of ${class:GtRlProject}$ that contains a graph of other ${class:GtRlProject}$ and ${class:GtRlRepository}$objects. Projects are contained within repositories and have dependencies to other projects contained in the same or other repositories.

This model is created using a ${class:GtRlDependenciesModelBuilder}$, by giving it a reference to the main baseline and the git url of the project (the url is needed as it is not present in the baseline). A shorter way to create a project is by sending the message ${method:BaselineOf class>>#gtRlProjectWithRepository:}$ to the baseline class.

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewHeight=300|previewExpanded}$

On top of this dependency model, a release model decorates projects and repositories with version numbers  and strategies for executing the actual release. The release model is an instance of ${class:GtRlProjectRelease}$  containing a graph of other ${class:GtRlProjectRelease}$ and ${class:GtRlRepositoryRelease}$objects. A ${class:GtRlProjectRelease}$decorates a previously created ${class:GtRlProject}$ object, and a ${class:GtRlRepositoryRelease}$ decorates a ${class:GtRlRepository}$ object. The relese model is created using an instance of ${class:GtRlReleaseBuilder}$ that gets as parameter the release configuration.

${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfigurationNoTest}$

Each ${class:GtRlRepositoryRelease}$ instance contains a version number and the release strategy used for projects in that repository. In this case, for all projects the version number is 'v0.1.0'  and the release is done on the dedicated branch 'release'. 

${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewShow=#gtProjectMapFor:|previewHeight=300|noCode}$

In the view above several projects are colored in gray. That indicates that the baselines of those projects do not need to change. For example, when creating the release for the project with the baseline ${class:BaselineOfGtRlBaselineExampleComponentA}$, as it has no dependencies, we do not need to update its baseline. For the project ${class:BaselineOfGtRlBaselineExampleSystemOne}$ however we need to update the baseline to load the new versions for all dependencies. 

We can also look at these projects by grouping them based on the repository that contains them.

${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewHeight=450|noCode}$

One restriction in GtReleaser is that is uses the same version number for all projects contained in a repository. For example, the repository =='github://example/ComponentB/src'==  contains two projects, 'GtRlBaselineExampleComponentBMain' and 'GtRlBaselineExampleComponentBUtil'. When refering to either one of these from another baseline the version number associated with the repository is used. This happens as version numbers identify commits within a repository (for example using tags) and it is only possible to checkout a single commit at a time.

When executing the release certain actions are performed within each repository. This list of actions is stored within the release objects and we can view it by inspecting those release objects. We use explicit action objects to allow users to see what will happen when executing the release. For example, below we look at the actions associate with the repository release =='github://example/SystemOne/src'==.

${example:GtRlReleaserUsageExamples>>#repositoryReleaseWithNoVersionAndDefaultConfiguration|previewShow=#gtReleaseActionsFor:|previewHeight=200|noCode}$

Among others we observe that the release updates the baseline and is performed on the 'release' branch by pushing a tag. The 'Order' column shown the relative order of an action in regard with all other actions performed during the release. Actions can differer between repositories. If we look below at the actions associated with the repository =='github://example/ComponentA/src'==, we observe that there is no action for compiling the baseline, as the baseline has no dependencies. If no action is needed for a repository, then the entire repository is highlighted in gray (this is not the case for this release).

${example:GtRlReleaserUsageExamples>>#repositoryReleaseComponentAWithNoVersionAndDefaultConfiguration|previewShow=#gtReleaseActionsFor:|previewHeight=200|noCode}$

To finally execute the release we instatiate the class ${class:GtRlReleaserExportWorkflow}$ and call the method ${method:GtRlReleaserExportWorkflow>>#executeReleaseActions}$. This performs all actions associated with the release including updating baselines and pushing changes, if needed.

${example:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionRepoAndDefaultConfigurationNoTest}$

We use a dedicated export object for performing the release as it allows us to better explore the release actions. For example, after building the exporter we can inspect it to see the list of all actions. For that we have two views, 'Creation actions' and `Post actions`. 

The creation actions are all those actions executed for creating the release:
${example:GtRlReleaserUsageExamples>>#releaseWorkflowNoVersionRepoAndDefaultConfiguration|previewShow=#gtViewReleaseCreationActionsFor:|previewHeight=300|noCode}$

The post actions are executed after the release was created and now consist in pushing changes to the remove origin of a repository:
${example:GtRlReleaserUsageExamples>>#releaseWorkflowNoVersionRepoAndDefaultConfiguration|previewShow=#gtViewPostCreationActionsFor:|previewHeight=250|noCode}$

Based on the order column we can see that the post actions are executed after the creation actions. Often when debugging or manually creating a release it can be usefull to create the release, check that everything is as expected, and only afterwards push changes.

Taking a step back, the code below shows the complete detailed steps for creating a release. 
${example:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationFullScriptNoTest}$

The above steps are useful to understand in mode details how the release is performed. However, for simply performing a release without going into too many details, the short version shown the the previous section is a simpler choice.
${example:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest}$

!!Other types of releases
Until now we only looked as perfoming an initial release for a system using the default release configuration. In practice there are many other types of systems and release configurations. The following documents provide more details about othe types of releases for our example system:

- TODO: A second normal and forced release;
- TODO: Major and minor releases;
- TODO: A release with fix dependencies and dependencies to latest versions;
- TODO: Releasing on different branches.

Also in practice systems have many different way of expressing their loading configuration using baselines. The following documents cover release for systems having other dependencies between baselines:

- TODO: Releasing when all baselines are in the same repository.
${example:GtRlReleaserUsageExamples>>#systemTwoProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}$ 
${example:GtRlReleaserUsageExamples>>#systemTwoProject|previewShow=#gtRepoMapFor:|noCode|previewHeight=300}$ 
 
- TODO: Releasing when multiple baselines point to a common dependency.
${example:GtRlReleaserUsageExamples>>#systemThreeProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}$ 

!!Package structure
This section describes the most important packages from GtReleaser:

- GToolkit-Releaser-BaselineModel: The model for capturing Monticello baselines together with their dependencies; 
- GToolkit-Releaser-BaselineModel-MinimalIceberg: An implementation for an in-memory iceberg repository needed in examples for documentation;
- GToolkit-Releaser-BaselineModel-Examples: Tests and documentation for the modeling dependencies in GtReleaser;
- GToolkit-Releaser: The model for creating new releases according to a release condiguration;
- GToolkit-Releaser-IcebergExtensions: A set of extensions to mae working with Iceberg objects easier in the inspector;
- GToolkit-Releaser-ExamplesExplorer: A tool for exploring and running examples attached to a project;
- GToolkit-Releaser-Examples: Tests and documentation for performing releases.

!!Testing GtReleaser
On a note about testing, GtReleaser uses examples for both testing and documentation. However, two different kind of examples are currently used.

For testing the functionality GtReleaser uses examples that create concrete git repos using libgit2. These example then delete the created repos in the after method. Hence, they cannot be used at the moment for documentation purposes, as it is harder to embedd views of repositories within documents when the repository no longer exists. These examples also aim to test GtReleaser in its normal usage.

That is why for documentation, different examples are used that rely on in-memory mocked repositories, instead of real git repositories on disk. Currently GtReleaser has its own implementation of these mocks in the package 'GToolkit-Releaser-BaselineModel-MinimalIceberg'. This implements the minimal API from Iceberg needed to make the documentation work. Iceberg also provides a package. `Iceberg-Memory`, that provides similar functionality. We are not using it given that it is not present in the Pharo image by default and introduces a dependency to Ring2. Ideally if that package is present in the image it could be used instead of the custom mocks.

!!Current limitations 



"
Class {
	#name : #GtRlReleaserUsageExamples,
	#superclass : #Object,
	#traits : 'TGtRlReleaseBuildAssertions',
	#classTraits : 'TGtRlReleaseBuildAssertions classTrait',
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #assertions }
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

{ #category : #'examples - configs' }
GtRlReleaserUsageExamples >> basicReleaseConfiguration [
	<gtExample>
	| configuration |
	configuration := GtRlReleaseConfiguration new.
	^ configuration
]

{ #category : #'examples - workflows' }
GtRlReleaserUsageExamples >> executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest [
	<gtExample>
	<noTest>
	| baseline project releaseExporter |
	baseline := BaselineOfGtRlBaselineExampleSystemOne.
	project := baseline 
		gtRlProjectWithRepository: 'github://example/SystemOne/src'. 
	releaseExporter := project 
		exporterWithConfiguration: GtRlReleaseConfiguration new.
	^ releaseExporter executeReleaseActions
]

{ #category : #'examples - workflows' }
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
	releaseExporter executeReleaseActions.
	^ releaseExporter
	
]

{ #category : #'examples - workflows' }
GtRlReleaserUsageExamples >> executedReleaseWorkflowNoVersionRepoAndDefaultConfigurationNoTest [
	<gtExample> 
	<noTest>	
	| release releaseExporter |
	release := self releaseWithNoVersionAndDefaultConfigurationNoTest.
	releaseExporter := GtRlReleaserExportWorkflow new
		rootProjectRelease: release. 
	releaseExporter executeReleaseActions.
	^ releaseExporter
]

{ #category : #'examples - releases' }
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

{ #category : #'examples - releases' }
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

{ #category : #'examples - workflows' }
GtRlReleaserUsageExamples >> releaseWorkflowNoVersionRepoAndDefaultConfiguration [
	<gtExample> 
	| release releaseExporter |
	release := self releaseWithNoVersionAndDefaultConfiguration.
	releaseExporter := GtRlReleaserExportWorkflow new
		rootProjectRelease: release. 
	^ releaseExporter
	
	
]

{ #category : #'examples - releases' }
GtRlReleaserUsageExamples >> repositoryReleaseComponentAWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	| release | 
	release := self releaseWithNoVersionAndDefaultConfiguration.
	^ release repositoryRelease childRepositoryReleases detect: [ :aRelease |
		aRelease repository projectName = 'ComponentA' ]
]

{ #category : #'examples - releases' }
GtRlReleaserUsageExamples >> repositoryReleaseWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	| release | 
	release := self releaseWithNoVersionAndDefaultConfiguration.
	^ release repositoryRelease
]

{ #category : #util }
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

{ #category : #'examples - projects' }
GtRlReleaserUsageExamples >> systemOneProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: 'github://example/SystemOne/src'. 
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserUsageExamples >> systemOneProjectWithNoVersions [
	<gtExample>
	| project |
	project := self systemOneProject. 
	"For performing a release we need to attach a valid iceberg repo to the contained projects"
	self setIcebergRepositoriesWithNoVersionFor: project.
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserUsageExamples >> systemThreeProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemThree
		withRepositoryDescription: 'github://example/SystemThree/src'. 
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserUsageExamples >> systemTwoProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemTwo
		withRepositoryDescription: 'github://example/SystemTwo/src'. 
	^ project
]