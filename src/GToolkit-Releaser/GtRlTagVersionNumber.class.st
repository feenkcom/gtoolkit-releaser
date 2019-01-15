"
I use the tag name of an already existent tag from the repository as a version number. I should be used only if the tag with the given name already exists in the repository.
"
Class {
	#name : #GtRlTagVersionNumber,
	#superclass : #GtRlVersionNumber,
	#instVars : [
		'tagName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #comparing }
GtRlTagVersionNumber >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self tagName = anObject tagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> tagName [
	^ tagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> tagName: aTagName [
	self assert: [ aTagName notNil ] description: 'The tag name cannot be null'.
	self 
		assert: [ tagName isNil ]
		description: 'A version number hat uses a tag name should be immutable'.
	tagName := aTagName
]

{ #category : #accessing }
GtRlTagVersionNumber >> versionString [
	^ self tagName
]
