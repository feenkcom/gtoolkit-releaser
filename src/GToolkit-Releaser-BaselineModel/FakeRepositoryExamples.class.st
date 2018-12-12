Class {
	#name : #FakeRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aDependentGtRlProject [
	| projectBuilder project repository diff cls |
	IceRepository registry detect: [ :repo | repo name = #MockRepo ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: #DependentMockRepo.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: #DependentMockRepo.
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'github://feenkcom/DependentMockRepo/src'. " we only use the urls as dictionary keys in examples"
	self addBaselineCode: project toClass: cls withDependencies: {#MockRepo-> 'github://feenkcom/MockRepo/src'}.
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	^ project
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aDependentGtRlProjectRelease [
	<gtExample>
	| releaseConfiguration workflow project |
	project := self aDependentGtRlProject.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: project baselineClass  
		fromRepository: 'github://feenkcom/DependentMockRepo/src'
		withConfiguration: releaseConfiguration.
	workflow releaseActions.
	^ workflow rootProjectRelease 
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aGtRlProject [
	| projectBuilder project repository diff cls |
	IceRepository registry detect: [ :repo | repo name = #MockRepo ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: #MockRepo.
	projectBuilder := GtRlModelBuilder new.
	cls := self baselineClass: #MockRepo.
	project := projectBuilder 
		buildProjectFromBaselineClass: cls
		withRepositoryDescription: 'github://feenkcom/MockRepo/src'. " we only use the urls as dictionary keys in examples"
	self addBaselineCode: project toClass: cls.
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'baseline: method code'
			force: true.
	^ project
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aGtRlProjectRelease [
	<gtExample>
	| releaseConfiguration workflow project |
	project := self aGtRlProject.
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: project baselineClass  
		fromRepository: 'github://feenkcom/MockRepo/src'
		withConfiguration: releaseConfiguration.
	workflow releaseActions.
	^ workflow rootProjectRelease 
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> addBaselineCode: project toClass: cls [
	| baselinecode |
	baselinecode := project generateSourceWithProjectDependencies: Dictionary new.
	cls compile: baselinecode.
	^ cls
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
