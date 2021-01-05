Extension { #name : #GtRlRepository }

{ #category : #'*GToolkit-Releaser-Cloner' }
GtRlRepository >> ownerName [
	^ self url host
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
	| urlSegments |
	urlSegments := self url segments.
	^ urlSegments size = 1 
		ifTrue: [ '' ]
		ifFalse: [ urlSegments last ]
]
