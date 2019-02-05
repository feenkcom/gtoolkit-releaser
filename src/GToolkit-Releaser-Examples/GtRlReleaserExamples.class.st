"
!GToolkit-Releaser

!!Purpose

Releaser allows creating reproducible Pharo images from github Baselines. This is achieved by merging the master branch into the release branch, rewriting the baseline class repository URLs with the new version number and then tagging each repository with the version number so that the baseline will load.

!!Model
Each baseline is modeled as a ${class:name=GtRlProject}$ and each repository as a ${class:name=GtRlRepository}$.
A project can depend on other projects, as specified by it's baseline.
For example: ${method:name=BaselineOfGToolkitInspector>>#baseline:}$

!!How to use
Bootstrapping the releaser model is as easy as 
[[[ 
projectBuilder := GtRlModelBuilder new.
project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit'.
]]]

!!!Project with no dependencies
For demo purposes, we've programatically created an example project: ${example:GtRlReleaserExamples>>#perpetualReleaseProject}$. 
!!!Executing a release
Executing a release involves using a configuration ${class:name=GtRlReleaseConfiguration}$, a release builder ${class:name=GtRlReleaseBuilder}$ and a ${class:name=GtRlReleaserExportWorkflow}$:
${example:GtRlReleaserExamples>>#executePerpetualReleaseProject}$

!!!Project with dependencies
Releaser will recusively go through the entire repository graph and execute the release. However, there are cases where a Releaser should not execute any actions, or where the dependency should be on a certain commit id or a tag. The following example shows a generated repository that dependens in multiple ways on other generated repositories. 
${example:GtRlReleaserExamples>>#createProjectWithDependencies}$

The way in which it depends on the other repositories is defined in the release configuration by configuring different release strategies for different projects. 

	- GtRlLeafProjectReleaseStrategy will create a new release if the repository has new commits
	- GtRlDedicatedBranchReleaseStrategy will create a new release if the repository has new commits or if any of its dependencies has new commits
	- GtRlBaselineTagReleaseStrategy allows setting a dependency to a specific version defined by a git tag
	- GtRlLatestCommitReleaseStrategy allows depending on the latest commit of a third party repository (such as a library)

Releaser is debuggable in the sense that a Workflow will have a list of action objects ready to be inspected before any actual change has been made to any repository. The actions can be viewed in the ""Release actions"" tab of a GtRlReleaserExportWorkflow object.

"
Class {
	#name : #GtRlReleaserExamples,
	#superclass : #Object,
	#instVars : [
		'repositories'
	],
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #'creation projects' }
GtRlReleaserExamples >> addNewMethodNamed: methodSelector toProject: targetProject [
	targetProject baselineClass compileSilently: methodSelector,' 
	"I am a new method"
	^ 1 + 2 + 3' classified: 'new method'.
	targetProject baselineClass package addMethod: targetProject baselineClass >> methodSelector.
]

{ #category : #assertions }
GtRlReleaserExamples >> assertExecutedActions: releaseActions [
	releaseActions do: [ :aReleaseAction |
		self assert: aReleaseAction isExecuted  ]
]

{ #category : #assertions }
GtRlReleaserExamples >> assertNewReleaseTagOnReleaseBranchFor: icebergRepository named: aString [
	| headCommitTags |
	headCommitTags := icebergRepository head commit tags.
	self assert: icebergRepository branchName equals: 'release'.
	self assert: headCommitTags size equals: 1.
	self assert: headCommitTags first gtIsSemanticVersion.
	self assert: headCommitTags first name equals: aString.
]

{ #category : #assertions }
GtRlReleaserExamples >> assertReleaseActions: aRelease equalTypes: expectedActionTypesWithOrder [
	| obtainedActions |
	obtainedActions := aRelease releaseActions actions.
	self assert: obtainedActions size equals: expectedActionTypesWithOrder size.
	expectedActionTypesWithOrder withIndexDo: [ :actionData :index |
		| obtainedAction |
		obtainedAction := obtainedActions at: index.
		self assert: obtainedAction class equals: actionData key.
		self assert: obtainedAction order equals: actionData value ].
]

{ #category : #assertions }
GtRlReleaserExamples >> assertRepositoryReleaseWithBranchStrategy: repositoryRelease andExistingVersion: aVersion [
	self assert: repositoryRelease releaseStrategy shouldCreateNewRelease not.
	self assert: repositoryRelease isPassiveRelease.
	self assert: repositoryRelease version equals: aVersion.
	self assert: repositoryRelease releaseActions isEmpty.
	

]

{ #category : #assertions }
GtRlReleaserExamples >> assertRepositoryReleaseWithBranchStrategy: repositoryRelease andNewVersion: aVersion [
	self assert: repositoryRelease releaseStrategy shouldCreateNewRelease.
	self assert: repositoryRelease isPassiveRelease not.
	self assert: repositoryRelease version equals: aVersion.
	self assert: repositoryRelease releaseActions isEmpty not.
	

]

{ #category : #private }
GtRlReleaserExamples >> baselineClassForProjectName: projectName [
	^ Smalltalk classNamed: ('BaselineOf', projectName)
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> commiNewMethodNamed: methodSelector onMasterToProject: targetProject [
	| icebergRepository |
	icebergRepository := targetProject repository icebergRepository.
	(icebergRepository branchNamed: 'master') checkout.
	self addNewMethodNamed: #method1 toProject: targetProject.
	icebergRepository workingCopy 
		forceCalculateDirtyPackages
		commitWithMessage: 'added method named', methodSelector.
]

{ #category : #'creation baselines' }
GtRlReleaserExamples >> createBaselineForProjectNamed: projectName [
	^ self 
		createBaselineForProjectNamed: projectName 
		withDependencies: #()
]

{ #category : #'creation baselines' }
GtRlReleaserExamples >> createBaselineForProjectNamed: projectName withDependencies: baselineDependencies [
	| methodSourceCode dependenciesCode baselineClass baselinePackage | 
	baselinePackage := RPackage named: 'BaselineOf', projectName.
	
	SystemAnnouncer uniqueInstance suspendAllWhile: [ 
		baselineClass := BaselineOf subclass: 'BaselineOf', projectName
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'BaselineOf', projectName ].
	baselinePackage addClassDefinition: baselineClass.
	
	dependenciesCode := ''.
	baselineDependencies do: [ :aDependency |
		dependenciesCode := dependenciesCode, '
		spec 
			baseline: ''', aDependency key ,''' with: [
				spec repository: ''', aDependency value ,'''. ].' ].
	
	methodSourceCode := 'baseline: spec
	<baseline>
	spec for: #''common'' do: [',
dependenciesCode,'
	].'.
	
	baselineClass compileSilently: methodSourceCode classified: 'baseline'.
	baselinePackage addMethod: baselineClass>>#baseline:.
	
	SystemAnnouncer uniqueInstance suspendAllWhile: [ 
		RPackageOrganizer default registerPackage: baselinePackage ].
	^ baselineClass
]

{ #category : #'creation repositories' }
GtRlReleaserExamples >> createBasicIcebergRepositoryWithName: repositoryName [
	| repository reposioryFolder |
	
	reposioryFolder := (FileLocator localDirectory / #'gtoolkit-releaser' / repositoryName) asFileReference.
	self assert: reposioryFolder exists not.
	self assert: (IceRepository registry anySatisfy: [ :aRepo | aRepo name = repositoryName ]) not.
	
	repository := IceRepositoryCreator new
		location: reposioryFolder;
		subdirectory: 'src';
		ensureProjectFile;
		createNewRepositoryNamed: repositoryName.
	repository workingCopy 
		commitWithMessage: 'Add properties and project files'.

	"Ideally do not register the repository with Iceberg.
	Registered for now to make ot easy to debug."
	IceRepository registerRepository: repository. 
	
	"Ensure the repo was creates successfully"
	self assert: repository isMissing not.
	self assert: repository isModified not.
	self assert: repository branch name equals: 'master'.
	self assert: repository branch commits size equals: 1.
	
	^ repository
]

{ #category : #'creation repositories' }
GtRlReleaserExamples >> createIcebergRepositoryNamed: projectName withProjectDependencies: projectDependencies [
	| repository baselineClass |
	
	(self repositories includesKey: projectName) ifTrue: [ Error signal: 'Repository already present.' ].
	
	baselineClass := self 
		createBaselineForProjectNamed: projectName 
		withDependencies: (projectDependencies collect: [ :aProject | 
			aProject name -> aProject repository urlString ]).
	repository := self createBasicIcebergRepositoryWithName: projectName.
	repository workingCopy 
		addPackageNamed: baselineClass package name;
		commitWithMessage: 'baseline: method code'.
		
	self repositories at: projectName put: repository.

	^ repository
]

{ #category : #'creation repositories' }
GtRlReleaserExamples >> createIcebergRepositoryWithEmptyBaselineNamed: projectName [
	^ self createIcebergRepositoryNamed: projectName withProjectDependencies: #()
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> createSingleProjectWithName: projectName [
	| icebergRepository repository project |
	
	icebergRepository := self createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	repository := (GtRlRepository fromUrlString: (self urlStringForProjectNamed: projectName)) 
		icebergRepository: icebergRepository.
	project := (self instantiateAndInitializeProjectWithName: projectName)
		linkWithRepository: repository.
	^ project
]

{ #category : #'examples - configs' }
GtRlReleaserExamples >> defaultReleaseConfiguration [
	<gtExample>
	| releaseConfiguration |
	releaseConfiguration := GtRlReleaseConfiguration new
		defaultVersionNumber: (GtRlSemanticVersionNumber major: 0 minor: 1 patch: 0);
		defaultReleaseBranchName: 'release';
		defaultVersionComputation: GtRlMinorVersionComputation new.
		
	self assert: releaseConfiguration shouldForceNewRelease not.
	self assert: releaseConfiguration defaultReleaseBranchName equals: 'release'.
		
	^ releaseConfiguration
]

{ #category : #private }
GtRlReleaserExamples >> instantiateAndInitializeProjectWithName: projectName [
	| baselineClass |
	baselineClass := Smalltalk classNamed: ('BaselineOf', projectName).
	^ GtRlProject new
		name: projectName;
		baselineVersion: baselineClass project version;
		baselineClass: baselineClass
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectAWithNoVersion [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	"I create a project that has no released version."
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithNoVersionA'.
	
	icebergRepository := self createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	repository := (GtRlRepository fromUrlString: (self urlStringForProjectNamed: projectName)) 
		icebergRepository: icebergRepository.
	
	project := (self instantiateAndInitializeProjectWithName: projectName)
		linkWithRepository: repository.
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectBWithNoVersion [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	"I create a project that has no released version."
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithNoVersionB'.
	
	icebergRepository := self createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	repository := (GtRlRepository fromUrlString: (self urlStringForProjectNamed: projectName)) 
		icebergRepository: icebergRepository.
	
	project := (self instantiateAndInitializeProjectWithName: projectName)
		linkWithRepository: repository.
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectStructureWithFourDependencies [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	| project projectName projectA projectB projectC projectD icebergRepository |
	projectName := 'ProjectWithFourDependencies'.
	
	projectA := self projectAWithNoVersion.
	projectB := self projectBWithNoVersion.
	projectC := self projectWithTagAndNoVersion.
	projectD := self projectWithOneReleasedVersionAndNoChanges.
	
	icebergRepository := self 
		createIcebergRepositoryNamed: projectName 
		withProjectDependencies: {projectA . projectB . projectC . projectD}.
	
	project := GtRlModelBuilder new
		buildProjectFromBaselineClass: (self baselineClassForProjectName: projectName)
		withRepositoryDescription: (self urlStringForProjectNamed: projectName).
	
	self assert: project repository icebergRepository equals: icebergRepository.
	self assert: project childProjects size equals: 4.
	self 
		assert: (project childProjects collect: #name) asArray
		equals: #(
			'RepositoryWithNoVersionA' 
			'RepositoryWithNoVersionB' 
			'RepositoryWithTagAndNoVersion' 
			'ProjectWithReleasedVersionAndNoChanges' ).
	
	"Fix current issuues caused by projects not being loaded in the image"
	project metacelloToolbox: GtRlMetacelloToolBoxWithSpecs new.
	project childProjects do: [ :aProject |
		project metacelloToolbox addSpecForBaselineClass: aProject baselineClass ].
		
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectWithOneReleasedVersionAndChanges [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	"I create project for a repository that has one release and changes staged for commit."
	| project semanticTags icebergRepository |
	
	project := self createSingleProjectWithName: 'ProjectWithReleasedVersionAndChanges'.
	icebergRepository := project repository icebergRepository.
	self releaseNewVersionForProject: project.
	
	(icebergRepository branchNamed: 'master') checkout.
	self addNewMethodNamed: #method1 toProject: project.
	icebergRepository workingCopy forceCalculateDirtyPackages.
	
	semanticTags := icebergRepository gtSemanticVersionsTags.
	self assert: semanticTags size equals: 1.
	self assert: semanticTags first name equals: 'v0.1.0'.
	self assert: icebergRepository isModified.
	self assert: icebergRepository branchName equals: 'master'.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectWithOneReleasedVersionAndNewCommit [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	"I create project for a repository that has one release 
	and one more commit not yet part of a release."
	| project semanticTags icebergRepository |
	
	project := self createSingleProjectWithName: 'ProjectWithReleasedVersionAndNewCommit'.
	icebergRepository := project repository icebergRepository.
	self releaseNewVersionForProject: project.
	self commiNewMethodNamed: #method1 onMasterToProject: project.
	
	semanticTags := icebergRepository gtSemanticVersionsTags.
	self assert: semanticTags size equals: 1.
	self assert: semanticTags first name equals: 'v0.1.0'.
	self assert: semanticTags first commit ~= icebergRepository head commit.
	self assert: icebergRepository isModified not.
	self assert: icebergRepository branchName equals: 'master'.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectWithOneReleasedVersionAndNoChanges [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	"I create project for a repository that has one release and no new changes."
	| project releaseWorkflow semanticTags |
	
	project := self createSingleProjectWithName: 'ProjectWithReleasedVersionAndNoChanges'. 
	releaseWorkflow := GtRlReleaserExportWorkflow 
		forProject: project withConfiguration: self defaultReleaseConfiguration.
	releaseWorkflow executeReleaseActions.
	
	semanticTags := project repository icebergRepository gtSemanticVersionsTags.
	self assert: semanticTags size equals: 1.
	self assert: semanticTags first name equals: 'v0.1.0'.
	self assert: project repository icebergRepository branchName equals: 'release'.
	
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectWithTagAndNoVersion [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithTagAndNoVersion'.
	
	icebergRepository := self createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	icebergRepository createTag: 'tag-1.2.0'.
	repository := (GtRlRepository fromUrlString: (self urlStringForProjectNamed: projectName))
		icebergRepository: icebergRepository.
		
	project := (self instantiateAndInitializeProjectWithName: projectName)
		linkWithRepository: repository.
	^ project
]

{ #category : #'examples - configs' }
GtRlReleaserExamples >> releaseConfigurationForcingRelease [
	<gtExample>
	| releaseConfiguration |
	releaseConfiguration := self defaultReleaseConfiguration.
	releaseConfiguration forceNewRelease.
		
	self assert: releaseConfiguration shouldForceNewRelease.
		
	^ releaseConfiguration
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> releaseNewVersionForProject: project [
	| releaseWorkflow |
	releaseWorkflow := GtRlReleaserExportWorkflow 
		forProject: project withConfiguration: self defaultReleaseConfiguration.
	releaseWorkflow executeReleaseActions.
]

{ #category : #'setUp-tearDown' }
GtRlReleaserExamples >> removeRepositoriesAndCode [
	self repositories do: [ :anIcebergRepository |
		IceRepository registry 
			detect: [ :aRepo | aRepo name = anIcebergRepository name ] 
			ifFound: [ :aRepo | aRepo forget ].
		
		"Remove all packages from the system"
		anIcebergRepository workingCopy packages do: [ :aPackage |
			SystemAnnouncer uniqueInstance suspendAllWhile: [ 
				aPackage name asPackage removeFromSystem ] ].
		
		"Delete all files from disk related to this repository"
		anIcebergRepository workingCopy fileSystem ensureDeleteAll ].
	self repositories removeAll.
]

{ #category : #accessing }
GtRlReleaserExamples >> repositories [ 
	^ repositories ifNil: [ 
		repositories := IdentityDictionary new ]
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> switchAllToMasterForProject: project [
	(project repository withDeepCollect: #childRepositories) do: [ :aRepository |
		self assert: (aRepository icebergRepository hasLocalBranchNamed: 'master').
		(aRepository icebergRepository branchNamed: 'master') checkout ]
]

{ #category : #private }
GtRlReleaserExamples >> urlStringForProjectNamed: projectName [
	^ 'github://example/', projectName, '/src'
]
