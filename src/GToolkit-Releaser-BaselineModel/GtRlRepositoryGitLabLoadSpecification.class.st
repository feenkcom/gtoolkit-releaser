Class {
	#name : #GtRlRepositoryGitLabLoadSpecification,
	#superclass : #GtRlRepositoryLoadSpecification,
	#instVars : [
		'mcRepository',
		'hasProjectVersion'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #testing }
GtRlRepositoryGitLabLoadSpecification class >> isForUrlString: aString [
	^ aString beginsWith: 'gitlab://'
]

{ #category : #testing }
GtRlRepositoryGitLabLoadSpecification >> hasVersion [
	^ hasProjectVersion
]

{ #category : #'initialization ' }
GtRlRepositoryGitLabLoadSpecification >> initializeWithString: aString [
	| aSuffix |
	mcRepository := MCGitlabRepository parseLocation: aString version: nil.
	aSuffix := ':', mcRepository projectVersion, '/', mcRepository repoPath.
	hasProjectVersion := aString endsWith: aSuffix.
	(mcRepository repoPath includes: $/) ifTrue: [ 
		| aRepoPath anIndex aProjectPart aRepoPart |
		aRepoPath := mcRepository repoPath .
		anIndex := aRepoPath lastIndexOf: $/.
		aProjectPart := aRepoPath copyFrom: 1 to: anIndex - 1.
		aRepoPart := aRepoPath copyFrom: anIndex + 1 to: aRepoPath size.
		mcRepository projectPath: mcRepository projectPath, '/', aProjectPart.
		mcRepository repoPath: aRepoPart
	]
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> projectName [
	^ mcRepository projectPath
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> repositoryName [
	^ self projectName
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> specificationId [
	^ 'gitlab://' , mcRepository hostname , ':' , mcRepository projectPath , '/'
		, mcRepository repoPath
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> specificationString [
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'gitlab://';
				nextPutAll: mcRepository hostname;
				nextPut: $:;
				nextPutAll: mcRepository projectPath.

			hasProjectVersion
				ifTrue: [ aStream
						nextPut: $:;
						nextPutAll: mcRepository projectVersion ].

			aStream
				nextPutAll: '/';
				nextPutAll: mcRepository repoPath ]
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> urlWithVersion: aVersionString [
	<return: #String>
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'gitlab://';
				nextPutAll: mcRepository hostname;
				nextPut: $:;
				nextPutAll: mcRepository projectPath.

			aStream
				nextPut: $:;
				nextPutAll: aVersionString.

			aStream
				nextPutAll: '/';
				nextPutAll: mcRepository repoPath ]
]

{ #category : #accessing }
GtRlRepositoryGitLabLoadSpecification >> versionString [
	^ hasProjectVersion
		ifTrue: [ mcRepository projectVersion ]
		ifFalse: [ Error signal: 'The repository does not have a version number.' ]
]
