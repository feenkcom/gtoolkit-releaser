"
!!!GToolkit-Releaser

Releaser allows creating reproducible Pharo images from github Baselines. This is achieved by merging the master branch into the release branch, rewriting the baseline class repository URLs with the new version number and then tagging each repository with the version number so that the baseline will load.

Each baseline is modeled as a ${class:name=GtRlProject}$ and each repository as a ${class:name=GtRlRepository}$.
A project can depend on other projects, as specified by it's baseline.
For example: ${method:name=BaselineOfGToolkitInspector>>#baseline:}$

Bootstrapping the releaser model is as easy as 
[[[ 
projectBuilder := GtRlModelBuilder new.
project := projectBuilder 
		buildProjectFromBaselineClass: BaselineOfGToolkit
		withRepositoryDescription: 'github://feenkcom/gtoolkit'.
]]]

For demo purposes, we've programatically created an example project: ${example:ReleaserExamples>>#perpetualReleaseProject}$. 

Executing a release involves using a configuration ${class:name=GtRlReleaseConfiguration}$, a release builder ${class:name=GtRlReleaseBuilder}$ and a ${class:name=GtRlReleaserExportWorkflow}$:
${example:ReleaserExamples>>#executePerpetualReleaseProject}$

Releaser will recusively go through the entire repository graph and execute the release. However, there are cases where a Releaser should not execute any actions, or where the dependency should be on a certain commit id or a tag. The following example shows a generated repository that dependens in multiple ways on other generated repositories. 
${example:ReleaserExamples>>#createProjectWithDependencies}$

The way in which it depends on the other repositories is defined in the release configuration.

"
Class {
	#name : #ReleaserExamples,
	#superclass : #Object,
	#instVars : [
		'projects'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'setUp-tearDown' }
ReleaserExamples >> aGtRlProject: projectName withDependencies: dependencyNames [
	| projectBuilder project repository diff cls baselineName filetreeDir mcVersion|
	baselineName := (#BaselineOf, projectName) asSymbol.
	IceRepository registry detect: [ :repo | repo name = projectName ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: projectName.
	filetreeDir := (repository workingCopy fileSystem / 'src') fullName.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: projectName.
	
	mcVersion := cls project versions first.
	project := GtRlProject new
		name: (MetacelloScriptEngine baseNameOf: cls name); 
		baselineVersion: mcVersion;
		baselineClass: cls.
	
	projectBuilder updateDependenciesFor: project fromMCVersion: mcVersion.
	projectBuilder projectsByBaselineClass at: cls put: project.

	project addPackage: (GtRlPackage new name: baselineName; 
								dependencies: (dependencyNames collect: [ :each | each key ]) ).
								
	self addBaselineCode: project toClass: cls withDependencies: dependencyNames.
			
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'filetree://', filetreeDir.
						
	repository workingCopy addPackageNamed: baselineName.
	
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	
	(Metacello image
    project: projectName;
    list)
    detect: [ :each | true ]
    ifNone:  [
		Metacello new
	   baseline: projectName;
	   filetreeDirectory: filetreeDir;
	   load].

	^ project
]

{ #category : #creation }
ReleaserExamples >> aGtRlProject: projectName withDependencies: dependencyNames inRepository: repository [
	| projectBuilder project diff cls baselineName filetreeDir mcVersion|
	baselineName := (#BaselineOf, projectName) asSymbol.
	IceRepository registry detect: [ :repo | repo name = repository name ] ifFound: [:repo | repo forget].
	filetreeDir := (repository workingCopy fileSystem / 'src') fullName.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: projectName.
	
	mcVersion := cls project versions first.
	project := GtRlProject new
		name: (MetacelloScriptEngine baseNameOf: cls name); 
		baselineVersion: mcVersion;
		baselineClass: cls.
	
	projectBuilder updateDependenciesFor: project fromMCVersion: mcVersion.
	projectBuilder projectsByBaselineClass at: cls put: project.

	project addPackage: (GtRlPackage new name: baselineName; 
								dependencies: (dependencyNames collect: [ :each | each key ]) ).
								
	self addBaselineCode: project toClass: cls withDependencies: dependencyNames.
			
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'filetree://', filetreeDir.
						
	repository workingCopy addPackageNamed: baselineName.
	
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	
	(Metacello image
    project: projectName;
    list)
    detect: [ :each | true ]
    ifNone: [
		Metacello new
	   baseline: projectName;
	   filetreeDirectory: filetreeDir;
	   load].

	^ project
]

{ #category : #creation }
ReleaserExamples >> aGtRlProject: projectName withDependencies: dependencyNames inRepository: repository using: projectBuilder [
	| project diff cls baselineName filetreeDir mcVersion|
	baselineName := (#BaselineOf, projectName) asSymbol.
	IceRepository registry detect: [ :repo | repo name = repository name ] ifFound: [:repo | repo forget].
	filetreeDir := (repository workingCopy fileSystem / 'src') fullName.
	
	cls := self baselineClass: projectName.
	
	mcVersion := cls project versions first.
	project := GtRlProject new
		name: (MetacelloScriptEngine baseNameOf: cls name); 
		baselineVersion: mcVersion;
		baselineClass: cls.
	
	projectBuilder updateDependenciesFor: project fromMCVersion: mcVersion.
	projectBuilder projectsByBaselineClass at: cls put: project.

	project addPackage: (GtRlPackage new name: baselineName; 
								dependencies: (dependencyNames collect: [ :each | each key ]) ).
								
	self addBaselineCode: project toClass: cls withDependencies: dependencyNames.
			
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'filetree://', filetreeDir.
						
	repository workingCopy addPackageNamed: baselineName.
	
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	
	(Metacello image
    project: projectName;
    list)
    detect: [ :each | true ]
    ifNone: [
		Metacello new
	   baseline: projectName;
	   filetreeDirectory: filetreeDir;
	   load].

	^ project
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> aGtRlProjectRelease: projectName [
	| releaseConfiguration releaseBuilder project release |
	project := self aGtRlProject: projectName withDependencies: OrderedCollection new.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: releaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ GtRlReleaserExportWorkflow new
		rootProjectRelease: release

]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> addBaselineCode: project toClass: cls withDependencies: dependenciesMap [
	| baselinecode |
	baselinecode := project generateSourceWithProjectDependencies: dependenciesMap.
	cls compile: baselinecode.
	^ cls
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> baselineClass: project [
	| cls |
	cls := BaselineOf subclass:#BaselineOf, project
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'BaselineOf', project.
	cls compile: 'baseline: spec
	<baseline>'.
	^ cls
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> computeProjectURL: project [
	| projectURL stream  |
	stream := String new writeStream.
	project repository url printOn: stream.
	projectURL := stream contents.
	^ projectURL


]

{ #category : #creation }
ReleaserExamples >> createNewIceRepositoryRepository: repoName [
	| repo repoFolder |
	
	repoName asFileReference ensureDeleteAll .
	repoFolder := repoName asFileReference.
	repo := IceRepositoryCreator new
	location: repoFolder;
	subdirectory: 'src';
	createNewRepositoryNamed: repoName.
	IceRepository registerRepository: repo.
	^ repo
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> createNewRepoWithName: repoName [
	| repo repoFolder packagest baseline diff dotProjectText dotProperties dotProject|
	
	repoName asFileReference ensureDeleteAll .
	repoFolder := repoName asFileReference.
	repo := IceRepositoryCreator new
	location: repoFolder;
	subdirectory: 'src';
	createNewRepositoryNamed: repoName.

	dotProjectText := '{ ''srcDirectory'' : ''src'' }'.

	baseline := ( repoFolder / 'src' / ('BaselineOf', repoName)) ensureCreateDirectory.

	packagest := (baseline / 'package.st') ensureCreateFile.
	packagest writeStreamDo: [ :stream | stream nextPutAll: 'Package { #name : #BaselineOf'; nextPutAll: repoName; nextPutAll: ' }' ].

	dotProperties := (repoFolder / 'src' / '.properties') ensureCreateFile.
	dotProperties writeStreamDo: [ :stream | stream nextPutAll: '{ #format : #tonel }' ].

	dotProject := (repoFolder / '.project') ensureCreateFile.
	dotProject writeStreamDo: [ :stream | stream nextPutAll: dotProjectText ].

	repo workingCopy addPackage: (IcePackage named: #BaselineOf,repoName repository: repo).

	diff := repo workingCopyDiff.

	repo workingCopy 
			commitChanges: diff
			withMessage: 'initial version'
			force: true.
	repo name: repoName.
	IceRepository registerRepository: repo.
	^ repo
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> createProject: projectName [
	| project |
	project := self aGtRlProject: projectName withDependencies: OrderedCollection new.
	^ self computeProjectURL: project. 


]

{ #category : #example }
ReleaserExamples >> createProjectWithDependencies [
	<gtExample>
	| releaseConfiguration project releaseBuilder release tagProjectURL commitProjectURL latestProjectURL workflow releaseActions normalProjectURL |
	
	tagProjectURL := self createTagProject.
	commitProjectURL := self createProject: #CommitProject.
	latestProjectURL := self createProject: #LatestProject.
	normalProjectURL := self createProject: #NormalProject.
	
	project := self aGtRlProject: 
		#ExampleProject withDependencies: {#TagProject -> {tagProjectURL}.  
													 #CommitProject -> {commitProjectURL}. 
													 #LatestProject -> {latestProjectURL}.
													 #NormalProject -> {normalProjectURL}}.
												
	releaseConfiguration := self genericReleaseConfiguration.
	releaseConfiguration setReleaseStrategyOfType: 
		GtRlLeafProjectReleaseStrategy 
		forProjecs: { latestProjectURL };
	setReleaseStrategyOfType: 
		GtRlLatestCommitReleaseStrategy 
			forProjecs: { commitProjectURL};
	setReleaseStrategyOfType: 
		GtRlBaselineTagReleaseStrategy 
		forProjecs: { tagProjectURL }.
		
	releaseBuilder := GtRlReleaseBuilder new
		configuration: releaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	 
	workflow :=  GtRlReleaserExportWorkflow new
		rootProjectRelease: release;
		updateReleaseActions.
	releaseActions := workflow releaseActions actions.
	self assert: releaseActions first name = 'Merge to release branch'.
	self assert: releaseActions first repositoryRelease projectReleases first project name = 'NormalProject'.
	self assert: releaseActions fourth repositoryRelease projectReleases first project name = 'LatestProject'.
	self assert: releaseActions fifth repositoryRelease projectReleases first project name = 'ExampleProject'.
	^ workflow

]

{ #category : #example }
ReleaserExamples >> createRepoWithTwoProjects [
	<gtExample>
	| oneRepo anotherRepo mainRepo mainProject oneProject anotherProject oneProjectURL anotherProjectURL dependencies sideProject projectBuilder |
	projectBuilder := GtRlModelBuilder new.
	oneRepo := self createNewIceRepositoryRepository: #OneRepository.
	oneProject := self aGtRlProject: #OneProject withDependencies:(OrderedCollection new) inRepository: oneRepo using: projectBuilder. 
	
	anotherRepo := self createNewIceRepositoryRepository: #AnotherRepository.
	anotherProject := self aGtRlProject: #AnotherProject withDependencies:(OrderedCollection new) inRepository: anotherRepo.
	oneProjectURL := self computeProjectURL: oneProject.
	anotherProjectURL := self computeProjectURL: anotherProject.
	
	mainRepo := self createNewIceRepositoryRepository: #MainRepository.
	dependencies := {#OneProject -> {oneProjectURL}}.
	mainProject := self aGtRlProject: #MainProject withDependencies:dependencies inRepository: mainRepo using: projectBuilder.
	dependencies := {#AnotherProject -> {anotherProjectURL}}.
	sideProject := self aGtRlProject: #SideProject withDependencies:dependencies inRepository: mainRepo using: projectBuilder.
	^ sideProject repository
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> createTagProject [
	| releaseConfiguration tagProject tagProjectURL workflow|
	
	tagProject := ReleaserExamples new aGtRlProject: #TagProject withDependencies: OrderedCollection new.
	tagProjectURL := self computeProjectURL: tagProject.
	releaseConfiguration := self genericReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: tagProject baselineClass 
		fromRepository: tagProjectURL
		withConfiguration: releaseConfiguration.
	 workflow executeReleaseActions.
	"TODO: add assertions about actions"
	^ tagProjectURL


]

{ #category : #example }
ReleaserExamples >> executePerpetualReleaseProject [
	<gtExample>
	| project releaseConfiguration releaseBuilder release workflow iceRepository diff|
	project := self perpetualReleaseProject.
	releaseConfiguration := self genericReleaseConfiguration.
	
	releaseBuilder := GtRlReleaseBuilder new
		configuration: releaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	iceRepository := release repositoryRelease icebergRepository.
	diff := iceRepository workingCopyDiff.
		
	workflow :=  GtRlReleaserExportWorkflow new
		rootProjectRelease: release;
		updateReleaseActions.
	workflow executeReleaseActions.
	iceRepository workingCopy 
		commitChanges: diff
		withMessage: 'new commit'
		force: true.
	^ workflow
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> genericReleaseConfiguration [
^ GtRlReleaseConfiguration new
	defaultVersionNumber: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 1);
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> getProject: projectName [
	| project |
	projects ifNil: [ projects := IdentityDictionary new].
	projects keys 
		detect: [ :key | key includesSubstring: ('' join: { '/' . projectName . '/'}) ] 
		ifFound:[ :p | project := projects at: p. self inform: 'got it from cache' ] 
		ifNone:[ project := self aGtRlProject: projectName withDependencies: OrderedCollection new.
		 projects at:(self computeProjectURL: project) put: project].
	^ project.


]

{ #category : #example }
ReleaserExamples >> perpetualReleaseProject [
	<gtExample>
	^ self getProject: #PerpetualReleaseProject.
]

{ #category : #'setUp-tearDown' }
ReleaserExamples >> projects [ 
	^ projects
]
