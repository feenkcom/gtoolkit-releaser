"
I model an unknown node encountered in baseline that does not corespond to a package or project from that baseline.


"
Class {
	#name : #GtRlUnknownNode,
	#superclass : #GtRlNode,
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlUnknownNode class >> withName: projectName [
	^ self new
		name: projectName
]

{ #category : #testing }
GtRlUnknownNode >> isUnknownNode [
	^ true
]
