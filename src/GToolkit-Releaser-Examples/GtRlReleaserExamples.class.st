Class {
	#name : #GtRlReleaserExamples,
	#superclass : #Object,
	#traits : 'TGtRlReleaseBuildAssertions',
	#classTraits : 'TGtRlReleaseBuildAssertions classTrait',
	#instVars : [
		'repositories'
	],
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #'creation projects' }
GtRlReleaserExamples >> addNewMethodNamed: methodSelector toProject: targetProject [

	GtPharoCodeModifier current critical: [
		targetProject baselineClass compileSilently: methodSelector,' 
		"I am a new method"
		^ 1 + 2 + 3' classified: 'new method'.
		targetProject baselineClass package addMethod: targetProject baselineClass >> methodSelector ]
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

{ #category : #private }
GtRlReleaserExamples >> baselineClassForProjectName: projectName [
	^ Smalltalk classNamed: ('BaselineOf', projectName)
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> commiNewMethodNamed: methodSelector onMasterToProject: targetProject [
	| icebergRepository |
	icebergRepository := targetProject repository icebergRepository.
	
	"checkout ends up with MCPackageLoader>>basicLoad which may flush changes file"
	GtPharoCodeModifier current critical: [
		(icebergRepository branchNamed: 'master') checkout ].
	
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
	
	self 
		forPharo12: [
			baselinePackage := Package named: 'BaselineOf', projectName.
			GtPharoCodeModifier registerPackage: baselinePackage.
	
			baselineClass := GtPharoCodeModifier current
				createSubclassOf: BaselineOf
				named: 'BaselineOf', projectName
				package: 'BaselineOf', projectName ] 
		forPharo11AndPharo10: [
			baselinePackage := Package named: 'BaselineOf', projectName.
	
			SystemAnnouncer uniqueInstance suspendAllWhile: [ 
				baselineClass := GtPharoCodeModifier current
					createSubclassOf: BaselineOf
					named: 'BaselineOf', projectName
					package: 'BaselineOf', projectName ].
			baselinePackage addClassDefinition: baselineClass ].
	
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
	
	GtPharoCodeModifier current critical: [
		baselineClass compileSilently: methodSourceCode classified: 'baseline' ].
	
	baselinePackage addMethod: baselineClass>>#baseline:.
	
	self 
		forPharo12: [] 
		forPharo11AndPharo10: [
			SystemAnnouncer uniqueInstance suspendAllWhile: [ 
				GtPharoCodeModifier registerPackage: baselinePackage ] ].
	
	^ baselineClass
]

{ #category : #'creation repositories' }
GtRlReleaserExamples >> createBasicIcebergRepositoryWithName: repositoryName [
	| repository reposioryFolder |
	reposioryFolder := (self repositoryDirectory / repositoryName) asFileReference.
	self assert: reposioryFolder exists not.
	self
		assert: (IceRepository registry anySatisfy: [ :aRepo | aRepo name = repositoryName ])
				not.

	repository := IceRepository repositoryClass creatorClass new
			location: reposioryFolder;
			subdirectory: 'src';
			ensureProjectFile;
			createNewRepositoryNamed: repositoryName.
	repository workingCopy commitWithMessage: 'Add properties and project files'.	"Ideally do not register the repository with Iceberg.
	Registered for now to make ot easy to debug."
	IceRepository registerRepository: repository.	"Ensure the repo was creates successfully"
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
			aProject name -> aProject repository loadSpecificationString ]).
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
	<return: #GtRlReleaseConfiguration>
	| releaseConfiguration |
	releaseConfiguration := GtRlReleaseConfiguration new
			defaultVersionNumber: (GtRlSemanticVersionNumber
					major: 0
					minor: 1
					patch: 0);
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
	"I create a project that has no released version."

	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithNoVersionA'.

	icebergRepository := self
			createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	repository := (GtRlRepository
			fromUrlString: (self urlStringForProjectNamed: projectName))
			icebergRepository: icebergRepository.

	project := (self instantiateAndInitializeProjectWithName: projectName)
			linkWithRepository: repository.
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectBWithNoVersion [
	"I create a project that has no released version."

	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithNoVersionB'.

	icebergRepository := self
			createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	repository := (GtRlRepository
			fromUrlString: (self urlStringForProjectNamed: projectName))
			icebergRepository: icebergRepository.

	project := (self instantiateAndInitializeProjectWithName: projectName)
			linkWithRepository: repository.
	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectStructureWithOneChildDependency [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| rootProject projectName childProject icebergRepository |
	projectName := 'ProjectWithOneChildDependency'.
	childProject := self projectBWithNoVersion.
	icebergRepository := self
			createIcebergRepositoryNamed: projectName
			withProjectDependencies: {childProject}.

	rootProject := GtRlDependenciesModelBuilder new
			buildProjectFromBaselineClass: (self baselineClassForProjectName: projectName)
			withRepositoryDescription: (self urlStringForProjectNamed: projectName).

	self assert: rootProject repository icebergRepository equals: icebergRepository.
	self assert: rootProject childProjects size equals: 1.
	self
		assert: (rootProject childProjects collect: #name) asArray
		equals: #('RepositoryWithNoVersionB').	"Fix current issues caused by projects not being loaded in the image"
	rootProject metacelloToolbox: GtRlMetacelloToolBoxWithSpecs new.
	rootProject childProjects
		do: [ :aProject | rootProject metacelloToolbox addSpecForBaselineClass: aProject baselineClass ].

	^ rootProject
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectStructureWithThreeDependencies [
	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| project projectName projectA projectB projectC icebergRepository |
	projectName := 'ProjectWithThreeDependencies'.

	projectA := self projectAWithNoVersion.
	projectB := self projectWithTagAndNoVersion.
	projectC := self projectWithOneReleasedVersionAndNoChanges.

	icebergRepository := self
			createIcebergRepositoryNamed: projectName
			withProjectDependencies: {projectA.
					projectB.
					projectC}.

	project := GtRlDependenciesModelBuilder new
			buildProjectFromBaselineClass: (self baselineClassForProjectName: projectName)
			withRepositoryDescription: (self urlStringForProjectNamed: projectName).

	self assert: project repository icebergRepository equals: icebergRepository.
	self assert: project childProjects size equals: 3.
	self
		assert: (project childProjects collect: #name) asArray
		equals: #('RepositoryWithNoVersionA' 'RepositoryWithTagAndNoVersion' 'ProjectWithReleasedVersionAndNoChanges').	"Fix current issues caused by projects not being loaded in the image"
	project metacelloToolbox: GtRlMetacelloToolBoxWithSpecs new.
	project childProjects
		do: [ :aProject | project metacelloToolbox addSpecForBaselineClass: aProject baselineClass ].

	^ project
]

{ #category : #'examples - projects' }
GtRlReleaserExamples >> projectWithOneReleasedVersionAndChanges [
	"I create project for a repository that has one release and changes staged for commit."

	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #AssertionFailure>
	| project semanticTags icebergRepository |
	project := self
			createSingleProjectWithName: 'ProjectWithReleasedVersionAndChanges'.
	icebergRepository := project repository icebergRepository.
	self releaseNewVersionForProject: project.	"checkout ends up with MCPackageLoader>>basicLoad which may flush changes file"
	GtPharoCodeModifier current
		critical: [ (icebergRepository branchNamed: 'master') checkout ].

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
	"I create project for a repository that has one release 
	and one more commit not yet part of a release."

	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| project semanticTags icebergRepository |
	project := self
			createSingleProjectWithName: 'ProjectWithReleasedVersionAndNewCommit'.
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
	"I create project for a repository that has one release and no new changes."

	<gtExample>
	<after: #removeRepositoriesAndCode>
	<return: #RPackageConflictError>
	| project releaseWorkflow semanticTags |
	project := self
			createSingleProjectWithName: 'ProjectWithReleasedVersionAndNoChanges'.
	releaseWorkflow := GtRlReleaserExportWorkflow
			forProject: project
			withConfiguration: self defaultReleaseConfiguration.
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
	<return: #RPackageConflictError>
	| projectName icebergRepository repository project |
	projectName := 'RepositoryWithTagAndNoVersion'.

	icebergRepository := self
			createIcebergRepositoryWithEmptyBaselineNamed: projectName.
	icebergRepository createTag: 'tag-1.2.0'.
	repository := (GtRlRepository
			fromUrlString: (self urlStringForProjectNamed: projectName))
			icebergRepository: icebergRepository.

	project := (self instantiateAndInitializeProjectWithName: projectName)
			linkWithRepository: repository.
	^ project
]

{ #category : #'examples - configs' }
GtRlReleaserExamples >> releaseConfigurationForcingRelease [
	<gtExample>
	<return: #GtRlReleaseConfiguration>
	| releaseConfiguration |
	releaseConfiguration := self defaultReleaseConfiguration.
	releaseConfiguration forceNewRelease.

	self assert: releaseConfiguration shouldForceNewRelease.

	^ releaseConfiguration
]

{ #category : #'examples - configs' }
GtRlReleaserExamples >> releaseConfigurationWithHeadCommitStrategyForChild [
	<gtExample>
	<return: #GtRlReleaseConfiguration>
	| releaseConfiguration |
	releaseConfiguration := self defaultReleaseConfiguration.
	releaseConfiguration
		setReleaseStrategyOfType: GtRlHeadCommitReleaseStrategy
		forProjecs: {'github://example/RepositoryWithNoVersionB/src'}.

	^ releaseConfiguration
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> releaseNewVersionForProject: project [
	^ self releaseNewVersionForProject: project usingConfig: self defaultReleaseConfiguration
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> releaseNewVersionForProject: project usingConfig: aReleaseConfiguration [
	| releaseWorkflow |
	releaseWorkflow := GtRlReleaserExportWorkflow 
		forProject: project withConfiguration: aReleaseConfiguration.
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
				GtPharoCodeModifier removePackageNamed: aPackage name ] ].

		"Delete all files from disk related to this repository"
		anIcebergRepository workingCopy fileSystem ensureDeleteAll ].
	self repositories removeAll.
	self repositoryDirectory ensureDeleteAll.
]

{ #category : #accessing }
GtRlReleaserExamples >> repositories [ 
	^ repositories ifNil: [ 
		repositories := IdentityDictionary new ]
]

{ #category : #'creation repositories' }
GtRlReleaserExamples >> repositoryDirectory [
	^ FileLocator localDirectory / #'gtoolkit-releaser'
]

{ #category : #'creation projects' }
GtRlReleaserExamples >> switchAllToMasterForProject: project [
	(project repository withDeepCollect: #childRepositories) do: [ :aRepository |
		self assert: (aRepository icebergRepository hasLocalBranchNamed: 'master').
		"checkout ends up with MCPackageLoader>>basicLoad which may flush changes file"
		GtPharoCodeModifier current critical: [
			(aRepository icebergRepository branchNamed: 'master') checkout ] ]
]

{ #category : #private }
GtRlReleaserExamples >> urlStringForProjectNamed: projectName [
	^ 'github://example/', projectName, '/src'
]
