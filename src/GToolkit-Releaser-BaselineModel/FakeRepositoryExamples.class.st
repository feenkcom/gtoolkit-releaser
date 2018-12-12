Class {
	#name : #FakeRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aGtRlProject [
	| projectBuilder project repository diff|
	IceRepository registry detect: [ :repo | repo name = #MockRepo ] ifFound: [:repo | repo forget].
	repository := self createNewRepoWithName: #MockRepo.
	projectBuilder := GtRlModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: (self baselineOfMockRepo: #MockRepo)
		withRepositoryDescription: 'github://feenkcom/MockRepo/src'. " we only use the urls as dictionary keys in examples"
	self addBaselineCode: project.
	diff := repository workingCopyDiff.
	repository workingCopy 
			commitChanges: diff
			withMessage: 'initial version'
			force: true.
	^ project
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> aGtRlProjectRelease [
	<gtExample>
	| releaseConfiguration workflow |
	self aGtRlProject.
	releaseConfiguration := GtRlReleaserWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserWorkflow 
		forBaseline: (self baselineOfMockRepo: #MockRepo) 
		fromRepository: 'github://feenkcom/MockRepo/src'
		withConfiguration: releaseConfiguration.
	workflow releaseActions.
	^ workflow rootProjectRelease 
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> addBaselineCode: project [
	| cls name baselinecode |
	name := project name.
	cls := BaselineOf subclass:#BaselineOf, name
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'BaselineOf', name.
	baselinecode := project generateSourceWithProjectDependencies: Dictionary new.
	cls compile: baselinecode.
	^ cls
]

{ #category : #'setUp-tearDown' }
FakeRepositoryExamples >> baselineOfMockRepo: repoName [
	| cls |
	cls := BaselineOf subclass:#BaselineOf,repoName
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'BaselineOf',repoName.

	cls compile: 'baseline: spec 
		<baseline>
			spec for: #common do: [ 
			spec
				package: #BaselineOf',repoName,' ]'.
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
