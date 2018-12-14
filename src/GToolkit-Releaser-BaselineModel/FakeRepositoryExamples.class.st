Class {
	#name : #FakeRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #example }
FakeRepositoryExamples >> aDependentGtRlProjectRelease [
	<gtExample>
	| releaseConfiguration workflow project |
	project := self aGtRlProject: #DependentMockRepo withDependencies: {#MockRepo -> #('github://feenkcom/MockRepo/src')}.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: project baselineClass  
		fromRepository: 'github://feenkcom/DependentMockRepo/src'
		withConfiguration: releaseConfiguration.
	workflow releaseActions.
	^ workflow rootProjectRelease 
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aGtRlProject: projectName withDependencies: dependencyNames [
	| projectBuilder project repository diff cls baselineName |
	baselineName := (#BaselineOf, projectName) asSymbol.
	IceRepository registry detect: [ :repo | repo name = projectName ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: projectName.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: projectName.
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'github://feenkcom/', projectName, '/src'. 
	
	project addPackage: (GtRlPackage new name: baselineName; 
								dependencies: (dependencyNames collect: [ :each | each key ]) ).
	self addBaselineCode: project toClass: cls withDependencies: dependencyNames.							
	repository workingCopy addPackageNamed: baselineName.
	
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	
	Smalltalk globals at: baselineName ifAbsent: [
		Metacello new
	   baseline: projectName;
	   filetreeDirectory: (repository workingCopy fileSystem / 'src') fullName;
	   load].

	^ project
]

{ #category : #example }
FakeRepositoryExamples >> aGtRlProjectRelease [
	<gtExample>
	| releaseConfiguration workflow project |
	project := self aGtRlProject: #MockRepo withDependencies: OrderedCollection new.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: project baselineClass  
		fromRepository: 'github://feenkcom/MockRepo/src'
		withConfiguration: releaseConfiguration.
	workflow releaseActions.
	^ workflow rootProjectRelease 
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> addBaselineCode: project toClass: cls withDependencies: dependenciesMap [
	| baselinecode |
	baselinecode := project generateSourceWithProjectDependencies: dependenciesMap.
	cls compile: baselinecode.
	^ cls
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> baselineClass: project [
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
FakeRepositoryExamples >> createNewRepoWithName: repoName [
	| repo repoFolder packagest baseline diff dotProjectText dotProperties dotProject|
	
	repoName asFileReference ensureDeleteAll .
	repoFolder := repoName asFileReference.
	repo:=IceRepositoryCreator new
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
