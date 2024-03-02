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
	self assert: repository = (GtRlRepository fromUrlString: repository loadSpecificationString).
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

	self assert: repository hash equals: (GtRlRepository fromUrlString: urlString) hash.
	self assert: repository hash ~= self repositoryWithGithubUrlNoVersion hash.
	
	^ repository
]

{ #category : #'examples - properties' }
GtRlRepositoryExamples >> repositoryHashNotEqualUrlExample [
	<gtExample>
	"I create a repository and verify that computing the hash works as expected."
	| repository urlString |
	urlString := 'github://example/gtoolkit:v0.2.1/src'.
	repository := GtRlRepository fromUrlString: urlString.

	self assert: (repository hash = urlString hash) not.
	
	^ repository
]

{ #category : #'examples - setup' }
GtRlRepositoryExamples >> repositoryWithFiletreeUrl [
	<gtExample>
	"I build a repository that uses a filetree url to identify a repository."
	| repository |
	repository := GtRlRepository fromUrlString: 'filetree:///Users/example/Documents/temp/repo'.
	
	self assert: repository projects isEmpty.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithFiletreeUrlHasCorrectId [
	<gtExample>
	| repository |
	repository := self repositoryWithFiletreeUrl.
	
	self assert: repository id equals: 'filetree:///Users/example/Documents/temp/repo'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithFiletreeUrlHasCorrectNames [
	<gtExample>
	"I build a repository that uses a filetree url to identify a repository."
	| repository |
	repository := self repositoryWithFiletreeUrl.
	
	self assert: repository projectName equals: 'Users'.
	self assert: repository repositoryName equals: 'temp'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithFiletreeUrlHasCorrectUrl [
	<gtExample>
	"I build a repository that uses a filetree url to identify a repository."
	| repository |
	repository := self repositoryWithFiletreeUrl.
	
	self assert: repository loadSpecificationString equals: 'filetree:///Users/example/Documents/temp/repo'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithFiletreeUrlHasNoVersion [
	<gtExample>
	"I build a repository that uses a filetree url to identify a repository."
	| repository |
	repository := self repositoryWithFiletreeUrl.
	
	self assert: repository hasVersion equals: false.
	self assert: repository versionStringOrNil isNil.
	
	^ repository
]

{ #category : #'examples - setup' }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersion [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/gtoolkit:v0.2.1/src'.
	
	self assert: repository projects isEmpty.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersionHasCorrectId [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := self repositoryWithGithubUrlExplicitTagVersion.
	
	self assert: repository id equals: 'github://example/gtoolkit/src'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersionHasCorrectNames [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := self repositoryWithGithubUrlExplicitTagVersion.
	
	self assert: repository projectName equals: 'gtoolkit'.
	self assert: repository repositoryName equals: 'gtoolkit'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersionHasCorrectUrl [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := self repositoryWithGithubUrlExplicitTagVersion.
	
	self assert: repository versionString equals: 'v0.2.1'.
	self assert: repository versionStringOrNil equals: 'v0.2.1'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlExplicitTagVersionHasCorrectVersion [
	<gtExample>
	"I build a repository that uses a Github url pointing to a tag instead of the latest version."
	| repository |
	repository := self repositoryWithGithubUrlExplicitTagVersion.
	
	self assert: repository versionString equals: 'v0.2.1'.
	self assert: repository versionStringOrNil equals: 'v0.2.1'.
	
	^ repository
]

{ #category : #'examples - setup' }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersion [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := GtRlRepository fromUrlString: 'github://example/gtoolkit/src'.
	
	self assert: repository projects isEmpty.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersionHasCorrectId [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := self repositoryWithGithubUrlNoVersion.
	
	self assert: repository id equals: 'github://example/gtoolkit/src'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersionHasCorrectNames [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := self repositoryWithGithubUrlNoVersion.
	
	self assert: repository projectName equals: 'gtoolkit'.
	self assert: repository repositoryName equals: 'gtoolkit'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersionHasCorrectUrl [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := self repositoryWithGithubUrlNoVersion.
	
	self assert: repository loadSpecificationString equals: 'github://example/gtoolkit/src'.
	
	^ repository
]

{ #category : #examples }
GtRlRepositoryExamples >> repositoryWithGithubUrlNoVersionHasNoVersion [
	<gtExample>
	"I build a repository that uses a Github url with no version information."
	| repository |
	repository := self repositoryWithGithubUrlNoVersion.
	
	self assert: repository hasVersion equals: false.
	self assert: repository versionStringOrNil isNil.
	
	^ repository
]
