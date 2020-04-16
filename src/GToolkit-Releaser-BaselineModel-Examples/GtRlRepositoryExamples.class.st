Class {
	#name : #GtRlRepositoryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - properties' }
GtRlRepositoryExamples >> repositoryEqualityExample [
	<gtExample>
	"I create a repository and verify that quality with other repositories works as expected."
	| repository |
	repository := self repositoryWithGithubUrlNoVersion.

	self assert: repository = repository.
	self assert: repository = (GtRlRepository fromUrlString: repository urlString).
	self assert: (repository = self repositoryWithGithubUrlExplicitTagVersion) not.
	
	^ repository
]

{ #category : #'examples - properties' }
GtRlRepositoryExamples >> repositoryHashExample [
	<gtExample>
	"I create a repository and verify that computing the hash works as expected."
	| repository urlString |
	urlString := 'github://example/gtoolkit:v0.2.1/src'.
	repository := GtRlRepository fromUrlString: urlString.

	self assert: repository hash equals: urlString hash.
	self assert: repository hash equals: (GtRlRepository fromUrlString: urlString) hash.
	self assert: repository hash ~= self repositoryWithGithubUrlNoVersion hash.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithFiletreeUrl [
	<gtExample>
	"I build a repository that uses a filetree url to identify a repository."
	| repository |
	repository := GtRlRepository new
		url: (ZnUrl fromString: 'filetree:///Users/example/Documents/temp/repo').
	
	self assert: repository hasVersion equals: false.
	self assert: repository id equals: 'filetree:///Users/example/Documents/temp/repo'.
	self assert: repository projectName equals: 'Users'.
	self assert: repository repositoryName equals: 'temp'.
	self assert: repository url equals: (ZnUrl fromString: 'filetree:///Users/example/Documents/temp/repo').
	self assert: repository urlString equals: 'filetree:///Users/example/Documents/temp/repo'.
	self assert: repository projects isEmpty.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersion [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := GtRlRepository new
		url: (ZnUrl fromString: 'github://example/gtoolkit:v0.2.1/src').
	
	self assert: repository hasVersion.
	self assert: repository id equals: 'github://example/gtoolkit/src'.
	self assert: repository projectName equals: 'gtoolkit'.
	self assert: repository repositoryName equals: 'gtoolkit'.
	self assert: repository url equals: (ZnUrl fromString: 'github://example/gtoolkit:v0.2.1/src').
	self assert: repository urlString equals: 'github://example/gtoolkit:v0.2.1/src'.
	self assert: repository projects isEmpty.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersion [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := GtRlRepository new
		url: (ZnUrl fromString: 'github://example/gtoolkit/src').
	
	self assert: repository hasVersion equals: false.
	self assert: repository id equals: 'github://example/gtoolkit/src'.
	self assert: repository projectName equals: 'gtoolkit'.
	self assert: repository repositoryName equals: 'gtoolkit'.
	self assert: repository url equals: (ZnUrl fromString: 'github://example/gtoolkit/src').
	self assert: repository urlString equals: 'github://example/gtoolkit/src'.
	self assert: repository projects isEmpty.
	
	^ repository
]
