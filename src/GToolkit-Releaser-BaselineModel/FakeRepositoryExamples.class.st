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
FakeRepositoryExamples >> mockRepo [
	| repo repoFolder baselineCode packagest baselineClass baseline cls diff dotProjectText dotProperties dotProject|
	
	'MockRepo' asFileReference ensureDeleteAll .
	repoFolder := 'MockRepo' asFileReference.

	repo:=IceRepositoryCreator new
	location: repoFolder;
	subdirectory: 'src';
	createNewRepositoryNamed: 'MockRepo'.

	baselineCode := 'Class {
		#name : #BaselineOfMockRepo,
		#superclass : #BaselineOf,
		#category : #BaselineOfMockRepo
	}
	{ #category : #baselines }
	BaselineOfMockRepo >> baseline: spec [
		<baseline>
			spec for: #common do: [ 
			spec
				package: #MockRepo ]
	]'.

	cls := BaselineOf subclass:#BaselineOfMockRepo
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'BaselineOfMockRepo'.

	cls compile: 'baseline: spec 
		<baseline>
			spec for: #common do: [ 
			spec
				package: #BaselineOfMockRepo ]'.

	dotProjectText := '{ ''srcDirectory'' : ''src'' }'.

	baseline := ( repoFolder / 'src' / 'BaselineOfMockRepo') ensureCreateDirectory.

	packagest := (baseline / 'package.st') ensureCreateFile.
	packagest writeStreamDo: [ :stream | stream nextPutAll: 'Package { #name : #BaselineOfMockRepo }' ].

	dotProperties := (repoFolder / 'src' / '.properties') ensureCreateFile.
	dotProperties writeStreamDo: [ :stream | stream nextPutAll: '{ #format : #tonel }' ].

	dotProject := ( repoFolder / '.project' ) ensureCreateFile.
	dotProject writeStreamDo: [ :stream | stream nextPutAll: dotProjectText ].

	baselineClass := (baseline / 'BaselineOfMockRepo.class.st') ensureCreateFile.
	baselineCode.
	baselineClass  writeStreamDo: [ :stream | stream nextPutAll: baselineCode. stream flush. ].

	repo workingCopy addPackage: (IcePackage named: #BaselineOfMockRepo repository: repo).

	diff := repo workingCopyDiff.

	repo workingCopy 
			commitChanges: diff
			withMessage: 'initial version'
			force: true.
	^ repo
]
