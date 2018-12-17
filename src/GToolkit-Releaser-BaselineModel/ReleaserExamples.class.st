Class {
	#name : #ReleaserExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #example }
ReleaserExamples >> aDependentGtRlProjectRelease [
	| releaseConfiguration project releaseBuilder release mockRepoFiletreeURL|
	IceRepository registry detect: [ :repo | repo name = 'MockRepo'] ifFound: [:repo | 
		mockRepoFiletreeURL := 'filetree://', repo codeDirectory absolutePath fullName. 
		project := self aGtRlProject: #DependentMockRepo withDependencies: {#MockRepo -> {mockRepoFiletreeURL}}.
		releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
		releaseBuilder := GtRlReleaseBuilder new
			configuration: releaseConfiguration. 
		release := releaseBuilder buildReleaseForProject: project.
		^ GtRlReleaserExportWorkflow new
			rootProjectRelease: release
	]
	

]

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
ReleaserExamples >> aGtRlProjectRelease [
	| releaseConfiguration releaseBuilder project release |
	project := self aGtRlProject: #MockRepo withDependencies: OrderedCollection new.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: releaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ GtRlReleaserExportWorkflow new
		rootProjectRelease: release

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

{ #category : #example }
ReleaserExamples >> createCommitProject [
	| commitProject stream commitProjectURL |
	commitProject := self aGtRlProject: #CommitProject withDependencies: OrderedCollection new. 
	stream := String new writeStream.
	commitProject repository url printOn: stream.
	commitProjectURL := stream contents.
	^ commitProjectURL


]

{ #category : #example }
ReleaserExamples >> createLatestProject [
	| latestProject stream latestProjectURL |
	latestProject := self aGtRlProject: #LatestProject withDependencies: OrderedCollection new.  
	stream := String new writeStream.
	latestProject repository url printOn: stream.
	latestProjectURL := stream contents.
	^ latestProjectURL


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
ReleaserExamples >> createProjectWithThreeDependencies [
	| releaseConfiguration project releaseBuilder release tagProjectURL commitProjectURL latestProjectURL |
	
	tagProjectURL := self createTagProject.
	commitProjectURL := self createCommitProject.
	latestProjectURL := self createLatestProject. 
	
	project := self aGtRlProject: 
		#ExampleProject withDependencies: {#TagProject -> {tagProjectURL}.  
														#CommitProject -> {commitProjectURL} . 
														#LatestProject -> {latestProjectURL}}.
												
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
	^ GtRlReleaserExportWorkflow new
		rootProjectRelease: release


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
