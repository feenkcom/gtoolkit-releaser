Extension { #name : #GtImage }

{ #category : #'*GToolkit-Releaser-Support' }
GtImage >> project: aName version: aGtRlSemanticVersionNumber [
	"Define a custom project version."
	^ self
		propertyAt: #projectVersion
		put: (GtImagePluggableProperty new
				name: aName;
				value: aGtRlSemanticVersionNumber;
				description: aGtRlSemanticVersionNumber versionString)
]

{ #category : #'*GToolkit-Releaser-Support' }
GtImage >> projectVersion [
	"Get a custom project version"

	<return: #GtRlSemanticVersionNumber or: nil>
	| aProperty |
	aProperty := self propertyAt: #projectVersion ifAbsent: [ ^ nil ].

	^ aProperty value
]
