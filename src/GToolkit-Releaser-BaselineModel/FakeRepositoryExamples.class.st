Class {
	#name : #FakeRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Tests'
}

{ #category : #'as yet unclassified' }
FakeRepositoryExamples >> inMemoryRepo [
	| repo repoFolder baselineCode packagest baselineClass baseline |
	repoFolder := (FileSystem memory root / 'MockRepo') .

	repo := IceRepositoryCreator new
	location: repoFolder;
	subdirectory: 'src';
	createNewRepositoryNamed: 'MockRepo'.

	baselineCode := 'Class {
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

	baseline := ( repoFolder / 'src' / 'BaselineOfMockRepo') ensureCreateDirectory.
	packagest := (baseline / 'package.st') ensureCreateFile.
	packagest writeStreamDo: [ :stream | stream nextPutAll: 'Package { #name : #MockRepo }' ].
	baselineClass := (baseline / 'BaselineOfMockrepo.class.st') ensureCreateFile.
	baselineClass  writeStreamDo: [ :stream | stream nextPutAll: baselineCode ].

	^ repo 
]
