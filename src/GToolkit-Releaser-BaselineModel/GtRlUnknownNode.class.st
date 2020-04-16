"
I model an known node encountered in baseline that does not corespond to a package or project from that baseline.
"
Class {
	#name : #GtRlUnknownNode,
	#superclass : #GtRlNode,
	#instVars : [
		'incomingDependencies'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlUnknownNode class >> withName: projectName [
	^ self new
		name: projectName
]

{ #category : #adding }
GtRlUnknownNode >> addIncomingDependency: aDependency [
	self incomingDependencies add: aDependency
]

{ #category : #accessing }
GtRlUnknownNode >> incomingDependencies [
	^ incomingDependencies
]

{ #category : #initialization }
GtRlUnknownNode >> initialize [
	super initialize.
	incomingDependencies := OrderedCollection new.
]

{ #category : #accessing }
GtRlUnknownNode >> outgoingDependencies [
	^ #()
]
