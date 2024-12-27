"
1. Releaser

This is the Releaser wiki, a live, interactive document living and evolving in the image. It contains details about Releaser, like its intent, usage, internal structure, as well rationale about various design decisions. 

1. # Overview

Releaser allows the creation of release versions for applications that use Metacello baselines to specify their loading configuration (what packages to load, their loading order and their dependencies). Releaser supports projects that use deeply nested baselines spread across many git repositories with a mix of baselines with fix dependencies and dependencies to latest versions. 

Releaser aims to be easy to debug. Several design decision, like computing all actions before executing a release and using separate models for releases and dependencies go in that direction. Releaser also uses extensively inspector views to help expose implementation details.

Currently GtRelease only provides support for generating new releases. However, in the context of Glamorous Toolkit, the goal is to extend it with support for loading baselines, not only generating them. Several other tools for working with a project (like running all tests in a project, or commiting changes to multiple repositories) could be based on Releaser.

In short, to create a new release a user has to: 
 - ensure that all the code of the application that needs to be released is loaded in the current image;
 - create a {{gtClass:GtRlReleaseConfiguration}} configuration controlling various aspects of the release process;
 - run the release exporter to create new Metacello baselines that use fix versions to load dependencies. 

Releases can be done manually from the image using the inspector as a user interface, or by relying on a command line handler.
The next sections introduce the main concepts of Releaser through examples. They show how to create new releases programatically on an example system using the inspector.

1. ## Example system 

To exemplify releaser in more details we use an example system that simulates a real system having multiple baselines spread across multiple repositories. The main baseline of this system is given by the class {{gtClass:BaselineOfGtRlBaselineExampleSystemOne}}. In total this project uses seven baselines with two levels of dependencies. The picture below shows the dependencies between these baselines.

{{gtExample:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}}

Another way to look at these baselines is to group them based on the repository containing them, as shown below. In this case we have six distinct repositories. One repository contains two baselines and the others a single baseline. For this example system, all repositories are github repositories belonging to the user .

{{gtExample:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtRepoMapFor:|noCode|previewHeight=300}} 

1. # Default configuration

Let's assume that we just started developing this system and we need to create the first release. As a first example, we use a standard configuration with default options. We can obtain it by instantiating the class {{gtClass:GtRlReleaseConfiguration}}.

{{gtExample:GtRlReleaserUsageExamples>>#basicReleaseConfiguration|previewShow=#gtDefaultOptionsFor:|previewHeight=200|previewExpanded}}

The main available options are:
	- : The strategy for creating the actual release. By default a new release is created on a dedicated release branch. Release strategies are subclasses of {{gtClass:GtRlReleaseStrategy}}:
	- : The dedicated release branch on which the release will be done, in case the strategy uses a release branch;
	- : The default version number in case there is no version already present in the repository;
	- : The strategy for computing the next version number in case a version already exists;
	- : Whether or not to force a new release if there are no changes in the repository.
	
By default a new release is created on the `'release'`  branch, starting at the semantic version `'v0.1.0'`  and incrementing the patch number. In case there are no new changes since the previous release a new release is not created. Several of these options can be configured per each individual repository. 

1. # Creating the initial release in a nutshell

To perform a relese we:
- create a project object modeling the loading configuration of a system; we create it starting from a Metacello baseline;
- create a release exporter for the project based on a release configuration;
- perform the release using the exporter.

The method below shows the code for creating the first release for our example system using the default configuration. 
{{gtExample:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest}}

Running the exporter creates a new branch named 'release' in all project repositories, tags the latest commit in those branches with the tag `'v0.1.0'`, and updates the project baseliens to load the new tag instead of the latest version. The figure below shows the dependencies between projects in the new release. 
{{gtExample:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewShow=#gtProjectMapFor:|previewHeight=250|noCode}}

1. # Creating the initial release step-by-step

Next we go in more details through the steps performed by Releaser when creating a release. This can prove useful when debugging problems or when looking to understand how Releaser works.

Releaser relies on two distinct models: one for capturing dependencies between baselines and another for generating the new release based on a given configuration. Before a new release is made the user needs to create the first model, capturing dependencies between baselines. This is an instance of {{gtClass:GtRlProject}} that contains a graph of other {{gtClass:GtRlProject}} and {{gtClass:GtRlRepository}}objects. Projects are contained within repositories and have dependencies to other projects contained in the same or other repositories.

This model is created using a {{gtClass:GtRlDependenciesModelBuilder}}, by giving it a reference to the main baseline and the git url of the project (the url is needed as it is not present in the baseline). A shorter way to create a project is by sending the message {{gtMethod:BaselineOf class>>#gtRlProjectWithRepository:}} to the baseline class.

{{gtExample:GtRlReleaserUsageExamples>>#systemOneProject|previewHeight=300|previewExpanded}}

On top of this dependency model, a release model decorates projects and repositories with version numbers  and strategies for executing the actual release. The release model is an instance of {{gtClass:GtRlProjectRelease}}  containing a graph of other {{gtClass:GtRlProjectRelease}} and {{gtClass:GtRlRepositoryRelease}}objects. A {{gtClass:GtRlProjectRelease}}decorates a previously created {{gtClass:GtRlProject}} object, and a {{gtClass:GtRlRepositoryRelease}} decorates a {{gtClass:GtRlRepository}} object. The relese model is created using an instance of {{gtClass:GtRlReleaseBuilder}} that gets as parameter the release configuration.

{{gtExample:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfigurationNoTest}}

Each {{gtClass:GtRlRepositoryRelease}} instance contains a version number and the release strategy used for projects in that repository. In this case, for all projects the version number is 'v0.1.0'  and the release is done on the dedicated branch 'release'. 

{{gtExample:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewShow=#gtProjectMapFor:|previewHeight=300|noCode}}

In the view above several projects are colored in gray. That indicates that the baselines of those projects do not need to change. For example, when creating the release for the project with the baseline {{gtClass:BaselineOfGtRlBaselineExampleComponentA}}, as it has no dependencies, we do not need to update its baseline. For the project {{gtClass:BaselineOfGtRlBaselineExampleSystemOne}} however we need to update the baseline to load the new versions for all dependencies. 

We can also look at these projects by grouping them based on the repository that contains them.

{{gtExample:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewHeight=450|noCode}}

One restriction in Releaser is that is uses the same version number for all projects contained in a repository. For example, the repository `'github://example/ComponentB/src'`  contains two projects, 'GtRlBaselineExampleComponentBMain' and 'GtRlBaselineExampleComponentBUtil'. When refering to either one of these from another baseline the version number associated with the repository is used. This happens as version numbers identify commits within a repository (for example using tags) and it is only possible to checkout a single commit at a time.

When executing the release certain actions are performed within each repository. This list of actions is stored within the release objects and we can view it by inspecting those release objects. We use explicit action objects to allow users to see what will happen when executing the release. For example, below we look at the actions associate with the repository release `'github://example/SystemOne/src'`.

{{gtExample:GtRlReleaserUsageExamples>>#repositoryReleaseWithNoVersionAndDefaultConfiguration|previewShow=#gtReleaseActionsFor:|previewHeight=200|noCode}}

Among others we observe that the release updates the baseline and is performed on the 'release' branch by pushing a tag. The 'Order' column shown the relative order of an action in regard with all other actions performed during the release. Actions can differ between repositories. If we look below at the actions associated with the repository `'github://example/ComponentA/src'`, we observe that there is no action for compiling the baseline, as the baseline has no dependencies. If no action is needed for a repository, then the entire repository is highlighted in gray (this is not the case for this release).

{{gtExample:GtRlReleaserUsageExamples>>#repositoryReleaseComponentAWithNoVersionAndDefaultConfiguration|previewShow=#gtReleaseActionsFor:|previewHeight=200|noCode}}

To finally perform the release we instatiate the class {{gtClass:GtRlReleaserExportWorkflow}} and execute all release actions. {{gtMethod:GtRlReleaserExportWorkflow>>#releaseCreationActions}}returns the actions that create the actual release (for example update baselines and create tags), and {{gtMethod:GtRlReleaserExportWorkflow>>#releasePostCreationActions}} the actions that should be executed after the release is created; they consists in actions for pushing changes to the remote branches. Alternatively  {{gtMethod:GtRlReleaserExportWorkflow>>#executeReleaseActions}} executes both these types of actions.

{{gtExample:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionRepoAndDefaultConfigurationNoTest}}

We use a dedicated export object for performing the release as it allows us to better explore the release actions. For example, after building the exporter we can inspect it to see the list of all actions. For that we have two views,  and . 

The creation actions are all those actions executed for creating the release:
{{gtExample:GtRlReleaserUsageExamples>>#releaseWorkflowNoVersionRepoAndDefaultConfiguration|previewShow=#gtViewReleaseCreationActionsFor:|previewHeight=300|noCode}}

The post actions are executed after the release was created and now consist in pushing changes to the remove origin of a repository:
{{gtExample:GtRlReleaserUsageExamples>>#releaseWorkflowNoVersionRepoAndDefaultConfiguration|previewShow=#gtViewPostCreationActionsFor:|previewHeight=250|noCode}}

Based on the order column we can see that the post actions are executed after the creation actions. Often when debugging or manually creating a release it can be useful to create the release, check that everything is as expected, and only afterwards push changes.

Taking a step back, the code below shows the complete detailed steps for creating a release. 
{{gtExample:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationFullScriptNoTest}}

The above steps are useful to understand in mode details how the release is performed. However, for simply performing a release without going into too many details, the short version shown the the previous section is a simpler choice.
{{gtExample:GtRlReleaserUsageExamples>>#executedReleaseWorkflowNoVersionAndDefaultConfigurationExampleScriptNoTest}}

1. # Exploring release actions

To get a better overview of what is going to happen during a release we can inspect the release actions. Each action has a 'Description' view containing a short overview of what that action does. For example, below we are inspecting the action doing a push for the repository `'github://example/SystemOne/src'`. 

{{gtExample:GtRlReleaserUsageExamples>>#systemOnePushReleaseAction|previewHeight=250|noCode}}

Actions also have views that give more details about how they affect the release. For example, the action for compiling the baseline {{gtClass:BaselineOfGtRlBaselineExampleSystemOne}} from the repository `'github://example/SystemOne/src'`  has a view that shows the new generated code for that baseline.
{{gtExample:GtRlReleaserUsageExamples>>#systemOneCompileBaselineReleaseAction|previewShow=#gtGeneratedSourceFor:|previewHeight=300|noCode}}

Similarly if we want to see what metadata is going to be exported for the repository `'github://example/SystemOne/src'` we can inspect the corresponding action which has a view showing the new content of the metadata file.
{{gtExample:GtRlReleaserUsageExamples>>#systemOneExportMetadataReleaseAction|previewShow=#gtBaselineVersionMetadataFor:|previewHeight=250|noCode}}

1. # Other types of releases

Until now we only looked as perfoming an initial release for a system using the default release configuration. In practice there are many other types of systems and release configurations. The following documents provide more details about othe types of releases for our example system:

- TODO: A second normal and forced release;
- TODO: Major and minor releases;
- TODO: A release with fix dependencies and dependencies to latest versions;
- TODO: Releasing on different branches.

Also in practice systems have many different way of expressing their loading configuration using baselines. The following documents cover release for systems having other dependencies between baselines:

- TODO: Releasing when all baselines are in the same repository.
{{gtExample:GtRlReleaserUsageExamples>>#systemTwoProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}} 
{{gtExample:GtRlReleaserUsageExamples>>#systemTwoProject|previewShow=#gtRepoMapFor:|noCode|previewHeight=300}} 
 
- TODO: Releasing when multiple baselines point to a common dependency.
{{gtExample:GtRlReleaserUsageExamples>>#systemThreeProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}} 

1. # Package structure

This section describes the most important packages from Releaser:

- GToolkit-Releaser-BaselineModel: The model for capturing Monticello baselines together with their dependencies; 
- GToolkit-Releaser-BaselineModel-MinimalIceberg: An implementation for an in-memory iceberg repository needed in examples for documentation;
- GToolkit-Releaser-BaselineModel-Examples: Tests and documentation for the modeling dependencies in Releaser;
- GToolkit-Releaser: The model for creating new releases according to a release condiguration;
- GToolkit-Releaser-IcebergExtensions: A set of extensions to mae working with Iceberg objects easier in the inspector;
- GToolkit-Releaser-ExamplesExplorer: A tool for exploring and running examples attached to a project;
- GToolkit-Releaser-Examples: Tests and documentation for performing releases.

1. # Testing Releaser

On a note about testing, Releaser uses examples for both testing and documentation. However, two different kinds of examples are currently used.

For testing the functionality Releaser uses examples that create concrete git repos using libgit2. These examples then delete the created repositories in the after method. Hence, they cannot be used at the moment for documentation purposes, as it is harder to embedd views of repositories within documents when the repository no longer exists. These examples also aim to test Releaser in its normal usage.

That is why for documentation, different examples are used that rely on in-memory mocked repositories, instead of real git repositories on disk. Currently Releaser has its own implementation of these mocks in the package 'GToolkit-Releaser-BaselineModel-MinimalIceberg'. This implements the minimal API from Iceberg needed to make the documentation work. Iceberg also provides a package. `Iceberg-Memory`, that provides similar functionality. We are not using it given that it is not present in the Pharo image by default and introduces a dependency to Ring2. Ideally if that package is present in the image it could be used instead of the custom mocks.

1. # Current limitations 

There are currently several limitations regarding the kind of projects and baselines Releaser can handle.

Regarding baselines, currently Releaser supports a subset of Monticello baselines that define only packages and dependencies to other baselines in the #common spec. This means that the main limitations are:
- no support for groups within baselines; to use Releaser you need to structure baselines in a way that does not use groups;
- only the #common spec is supported; there is currenly no support for predefined specs like pharo versions (#pharo6 or #pharo7 for example) or custom attributes;
- only dependencies to other baselines are supported; no dependencies to Metacello configurations can be used.

The main strategy used in Releaser for creating a new release is adding a tag on a dedicated release branch. This requires Releaser to merge the current branch into the release branch. The merge is done automatically using Iceberg. Currently there are cases, mostly related to removing packages not loaded into the image, that can cause the merge to fail. In that case you should do the merge manually.

Also to ensure that a proper release is created, most operations from Releaser contain assertions that check the state of the repository or of the baseline. The release will fail if an invalid situation is encountered. 




"
Class {
	#name : #BaselineOfGToolkitReleaser,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitReleaser
}

{ #category : #baseline }
BaselineOfGToolkitReleaser >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'DeepTraverser' with: [
				spec repository: 'github://feenkcom/DeepTraverser:v1.1.160/src' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:839881eafebdd79eeb88a2d29bf77d6c74e42075/repository' ].

		spec package: 'GToolkit-PharoMigrations'.
		spec package: 'GToolkit-Releaser-BaselineModel' with: [
			spec requires: #(#'GToolkit-PharoMigrations') ].
		spec package: 'GToolkit-Releaser' with: [
			spec requires: #(#'GToolkit-Releaser-BaselineModel') ].
		spec package: 'GToolkit-Releaser-IcebergExtensions' with: [
			spec requires: #(#'GToolkit-Releaser') ].
		spec package: 'GToolkit-Releaser-ExamplesExplorer' with: [
			spec requires: #(#'GToolkit-Releaser') ].
		spec package: 'GToolkit-Releaser-Cloner' with: [
			spec requires: #(#'GToolkit-Releaser-BaselineModel') ].
		spec package: 'GToolkit-Releaser-Loader' with: [
			spec requires: #(#'GToolkit-Releaser-Cloner') ].
		spec package: 'GToolkit-Releaser-Logging' with: [
			spec requires: #(#Beacon) ].
		spec package: 'GToolkit-Releaser-Jenkins'.
		spec package: 'GToolkit-Releaser-BaselineModel-SystemOneExamples'.
		spec package: 'GToolkit-Releaser-BaselineModel-SystemThreeExamples'.
		spec package: 'GToolkit-Releaser-BaselineModel-SystemTwoExamples'.
		spec package: 'GToolkit-Releaser-BaselineModel-StandaloneSystemsExamples'.
		spec package: 'GToolkit-Releaser-BaselineModel-SystemFiveExamples'.
		spec package: 'GToolkit-Releaser-BaselineModel-MinimalIceberg'.
		spec package: 'GToolkit-Releaser-BaselineModel-Examples' with: [
			spec requires: #(#'GToolkit-Releaser-BaselineModel-SystemOneExamples' #'GToolkit-Releaser-BaselineModel-SystemThreeExamples' #'GToolkit-Releaser-BaselineModel-SystemTwoExamples' #'GToolkit-Releaser-BaselineModel-StandaloneSystemsExamples' #'GToolkit-Releaser-BaselineModel-SystemFiveExamples' #'GToolkit-Releaser-BaselineModel-MinimalIceberg') ].
		spec package: 'GToolkit-Releaser-Examples' with: [
			spec requires: #(#'GToolkit-Releaser' #'GToolkit-Releaser-IcebergExtensions' #'GToolkit-Releaser-BaselineModel-Examples') ].
		spec package: 'GToolkit-Releaser-Support' with: [
			spec requires: #(#Beacon #'GToolkit-Releaser') ].
	]
]
