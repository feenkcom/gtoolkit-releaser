Extension { #name : #GtRlRepository }

{ #category : #'*GToolkit-Releaser-Loader' }
GtRlRepository >> ownerName [
	^ self url host
]

{ #category : #'*GToolkit-Releaser-Loader' }
GtRlRepository >> projectPath [
	| projectPath |
	projectPath := OrderedCollection new.
	projectPath add: self ownerName.
	projectPath add: self projectName.
	^ (RelativePath withAll: projectPath) pathString
]

{ #category : #'*GToolkit-Releaser-Loader' }
GtRlRepository >> repoPath [
	| urlSegments |
	urlSegments := self url segments.
	^ urlSegments size = 1 
		ifTrue: [ '' ]
		ifFalse: [ urlSegments last ]
]
