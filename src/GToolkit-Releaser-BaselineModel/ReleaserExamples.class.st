Class {
	#name : #ReleaserExamples,
	#superclass : #Object,
	#instVars : [
		'normalProjectURL'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'setUp-tearDown' }
ReleaserExamples >> aGtRlProject: projectName withDependencies: dependencyNames [
	| projectBuilder project repository diff cls baselineName filetreeDir |
	baselineName := (#BaselineOf, projectName) asSymbol.
	IceRepository registry detect: [ :repo | repo name = projectName ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: projectName.
	filetreeDir := (repository workingCopy fileSystem / 'src') fullName.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: projectName.
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'filetree://', filetreeDir. 

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

{ #category : #example }
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

{ #category : #example }
ReleaserExamples >> createProject: projectName [
	| project stream projectURL |
	project := self aGtRlProject: projectName withDependencies: OrderedCollection new. 
	stream := String new writeStream.
	project repository url printOn: stream.
	projectURL := stream contents.
	^ projectURL


]

{ #category : #example }
ReleaserExamples >> createProjectWithDependencies [
	<gtExample>
	| releaseConfiguration project releaseBuilder release tagProjectURL commitProjectURL latestProjectURL workflow releaseActions |
	
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
ReleaserExamples >> createTagProject [
	| releaseConfiguration tagProject stream tagProjectURL workflow|
	
	tagProject := ReleaserExamples new aGtRlProject: #TagProject withDependencies: OrderedCollection new.
	stream := String new writeStream.
	tagProject repository url printOn: stream.
	tagProjectURL := stream contents.
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
ReleaserExamples >> genericReleaseConfiguration [
^ GtRlReleaseConfiguration new
	defaultVersionNumber: (GtRlSemanticVersionNumber major:0 minor: 0 patch: 1);
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new
]
