Class {
	#name : #FakeRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'as yet unclassified' }
FakeRepositoryExamples >> baselineClassCode [
	^ 'Class {
		#name : #BaselineOfMockRepo,
		#superclass : #BaselineOf,
		#category : #BaselineOfMockRepo
	}

	{ #category : #baseline }
	BaselineOfMockRepo >> baseline: spec [
		<baseline>
			spec for: #common do: [ 
			spec
				package: #MockRepo ]
	]'.

]

{ #category : #'as yet unclassified' }
FakeRepositoryExamples >> mockRepo: repoName [
	| repo repoFolder baselineCode packagest baselineClass baseline cls diff dotProjectText dotProperties dotProject|
	
	repoName asFileReference ensureDeleteAll .
	repoFolder := repoName asFileReference.

	repo:=IceRepositoryCreator new
	location: repoFolder;
	subdirectory: 'src';
	createNewRepositoryNamed: repoName.

	baselineCode := 'Class {
		#name : #BaselineOf',repoName,',
		#superclass : #BaselineOf,
		#category : #BaselineOf',repoName,'
	}
	{ #category : #baselines }
	BaselineOf',repoName,' >> baseline: spec [
		<baseline>
			spec for: #common do: [ 
			spec
				package: #',repoName,' ]
	]'.

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

	dotProjectText := '{ ''srcDirectory'' : ''src'' }'.

	baseline := ( repoFolder / 'src' / 'BaselineOf',repoName) ensureCreateDirectory.

	packagest := (baseline / 'package.st') ensureCreateFile.
	packagest writeStreamDo: [ :stream | stream nextPutAll: 'Package { #name : #BaselineOf',repoName,' }' ].

	dotProperties := (repoFolder / 'src' / '.properties') ensureCreateFile.
	dotProperties writeStreamDo: [ :stream | stream nextPutAll: '{ #format : #tonel }' ].

	dotProject := ( repoFolder / '.project' ) ensureCreateFile.
	dotProject writeStreamDo: [ :stream | stream nextPutAll: dotProjectText ].

	baselineClass := (baseline / 'BaselineOf',repoName,'.class.st') ensureCreateFile.
	baselineCode.
	baselineClass  writeStreamDo: [ :stream | stream nextPutAll: baselineCode. stream flush. ].

	repo workingCopy addPackage: (IcePackage named: #BaselineOf,repoName repository: repo).

	diff := repo workingCopyDiff.

	repo workingCopy 
			commitChanges: diff
			withMessage: 'initial version'
			force: true.
	^ repo
]
