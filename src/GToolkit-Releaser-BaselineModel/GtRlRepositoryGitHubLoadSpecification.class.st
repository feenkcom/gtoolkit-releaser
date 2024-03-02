Class {
	#name : #GtRlRepositoryGitHubLoadSpecification,
	#superclass : #GtRlRepositoryLoadSpecification,
	#instVars : [
		'mcRepository',
		'hasProjectVersion'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #testing }
GtRlRepositoryGitHubLoadSpecification class >> isForUrlString: aString [
	^ false "aString beginsWith: 'github://'"
]

{ #category : #testing }
GtRlRepositoryGitHubLoadSpecification >> hasVersion [
	^ hasProjectVersion
]

{ #category : #accessing }
GtRlRepositoryGitHubLoadSpecification >> host [
	^ 'github.com'
]

{ #category : #'initialization ' }
GtRlRepositoryGitHubLoadSpecification >> initializeWithString: aString [
	| aSuffix |
	mcRepository := MCGitHubRepository parseLocation: aString version: nil.
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
GtRlRepositoryGitHubLoadSpecification >> projectName [
	^ ($/ split: mcRepository projectPath)
		ifNotEmpty: #last
		ifEmpty: [ mcRepository projectPath ]
]

{ #category : #accessing }
GtRlRepositoryGitHubLoadSpecification >> repositoryName [
	^ mcRepository projectPath
]

{ #category : #accessing }
GtRlRepositoryGitHubLoadSpecification >> specificationId [
	^ 'github://' , mcRepository projectPath , '/' , mcRepository repoPath
]

{ #category : #accessing }
GtRlRepositoryGitHubLoadSpecification >> specificationString [
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'github://';
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
GtRlRepositoryGitHubLoadSpecification >> urlWithVersion: aVersionString [
	<return: #String>
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'github://';
				nextPutAll: mcRepository projectPath.

			aStream
				nextPut: $:;
				nextPutAll: aVersionString.

			aStream
				nextPutAll: '/';
				nextPutAll: mcRepository repoPath ]
]

{ #category : #accessing }
GtRlRepositoryGitHubLoadSpecification >> versionString [
	^ hasProjectVersion
		ifTrue: [ mcRepository projectVersion ]
		ifFalse: [ Error signal: 'The repository does not have a version number.' ]
]
