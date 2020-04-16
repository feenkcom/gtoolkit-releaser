"
I am an abstraction for a type of dependency in the loading configuration of a system.
"
Class {
	#name : #GtRlNode,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'accessing - dynamic' }
GtRlNode >> dependencies [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRlNode >> name [
	^ name
]

{ #category : #accessing }
GtRlNode >> name: aString [
	self assert: [ aString notNil ].
	name := aString
]
