Extension { #name : #GtRlRepository }

{ #category : #'*GToolkit-Releaser-Cloner' }
GtRlRepository >> ownerName [
	^ self loadSpecification host
]

{ #category : #'*GToolkit-Releaser-Cloner' }
GtRlRepository >> projectPath [
	| projectPath |
	projectPath := OrderedCollection new.
	projectPath add: self ownerName.
	projectPath add: self projectName.
	^ (RelativePath withAll: projectPath) pathString
]

{ #category : #'*GToolkit-Releaser-Cloner' }
GtRlRepository >> repoPath [
	^ self loadSpecification repoPath
]
