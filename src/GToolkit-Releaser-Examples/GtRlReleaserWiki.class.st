"
!GtReleaser Wiki

This is the GtReleser wiki, a live, interactive document living and evolving in the image providing details about GtReleaser, like its intent, usage, internal structure, as well rationale about various design decisions. 

!! Overview 
GtReleaser allows the creation of release versions for applications that use baselines to specify their loading configuration, that is what packages to load, their loading order and their dependencies. GT Releaser works with projects that use deeply nested baselines spread across many git repositories with a mix of baselines with fix dependencies and dependencies to latest versions.

In short, to create a new release a user has to: 
 - ensure that all the code of the application that needs to be releases is loaded in the current image;
 - create a ${class:GtRlReleaseConfiguration}$ configuration controlling various aspects of the release process;
 - run the release exporter to create new versions and baselines that use those versions to load projects. 

The release can be done manually from the image using the inspector as a user interface, or by relying on a command line handler.
This sections introduces the main concepts in GtReleaser by showing how to create a few release versions programatically on an example system using the inspector.

!!! Example system 
To exemplify releaser in more details we use a dummy system that simulates a real system having multiple baselines spread across multiple repositories. The main baseline of this system is given by the class ${class:BaselineOfGtRlBaselineExampleSystemOne}$. In total this project uses seven baselines. The dependencies between these baselines are shown in the picture below.

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtProjectMapFor:|noCode|previewHeight=300}$

Another way to look at these baselines is to group them based on the repoitory containing them, as shown below. In our case we have six distinct repositories. One repository contains two baselines and the others a single baseline. For this dummny system, all repos are github repos belonging to the user *example*.

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewShow=#gtRepoMapFor:|noCode|previewHeight=300}$ 

!! Default configuration

Assuming that we just started developing this system and we do not have any release we need to create the first one. As a first example, we can use a standard configuration with default options. We can obtain it by instantiating the class ${class:GtRlReleaseConfiguration}$.

${example:GtRlReleaserUsageExamples>>#basicReleaseConfiguration|previewShow=#gtDefaultOptionsFor:|previewHeight=200|previewExpanded}$

The five available options are:
	- *Release strategy*: The strategy for creating the actual release. By default a new release is created on a dedicated release branch. The other available release strategies are subclasses of ${class:GtRlReleaseStrategy}$:
	- *Release branch*: The dedicated release branch where the release will be done, in case the strategy uses a release branch;
	- *Version number*: The default version number in case there is no version already present in the repository that can be incremented;
	- *Version computation*: The strategy for computing the next version number;
	- *Force release*: Whether or not to force a new release if there are no changes in the repository.
	
Several of these options can be configure for each indivudual repository from the loading configuration. Just by default a new release is created in the ==#release== branch, starting at the symbolic version =='v0.1.0' and incrementing the patch number. In case there are no new changes since the previous release a new release is not created.

!! Creating the initial release step-by-step

Internally GtReleaser relies on two distinct models: one for capturing the dependencies between baselines and another for generating the new release based on a given configuration. Before a new release can be made the user needs to create the first model, capturing dependencies between baselines. This is an instance of ${class:GtRlProject}$ and is created using a ${class:GtRlModelBuilder}$ by giving it a reference to the main baseline and the git url of the project (the url is needed as it is not present in the baseline).

${example:GtRlReleaserUsageExamples>>#systemOneProject|previewHeight=300|previewExpanded}$

On top of this dependency model, a release model indicates for each project what is the version number of the release. This is an instance of ${class:GtRlRepositoryRelease}$ and decorates the previously created project. This object is created using an instance of ${class:GtRlReleaseBuilder}$ that gets as a parameter a configuration.

${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfigurationNoTest}$

Running this code returns the release object, that adds information like version numbers to every release. 

${example:GtRlReleaserUsageExamples>>#releaseWithNoVersionAndDefaultConfiguration|previewShow=#gtProjectMapFor:|previewHeight=300|noCode}$




"
Class {
	#name : #GtRlReleaserWiki,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #'examples - configs' }
GtRlReleaserWiki >> basicReleaseConfiguration [
	<gtExample>
	| configuration |
	configuration := GtRlReleaseConfiguration new.
	^ configuration
]

{ #category : #'examples - releases' }
GtRlReleaserWiki >> releaseWithNoVersionAndDefaultConfiguration [
	<gtExample> 
	<noTest>	
	| project release releaseBuilder |
	project := self systemOneProjectWithNoVersions.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: self basicReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ release
]

{ #category : #'examples - releases' }
GtRlReleaserWiki >> releaseWithNoVersionAndDefaultConfigurationNoTest [
	<gtExample> 
	<noTest>	
	| project release releaseBuilder |
	project := self systemOneProject.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: self basicReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ release
]

{ #category : #'examples - projects' }
GtRlReleaserWiki >> systemOneProject [
	<gtExample>
	| projectBuilder project |
	projectBuilder := GtRlModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleSystemOne
		withRepositoryDescription: 'github://example/SystemOne/src'. 
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserWiki >> systemOneProjectWithNoVersions [
	<gtExample>
	| project |
	project := self systemOneProject. 
	project withAllRepositories do: [ :aReposiory |
		aReposiory icebergRepository: (GtRlIceMinimalRepository new
			name: aReposiory repositoryName;
			setHead: (GtRlIceMinimalBranch new
				name: 'master'))].
	^ project
]
