"
I model an known node encountered in baseline that does not corespond to a package or project from that baseline.
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

{ #category : #'accessing - dynamic' }
GtRlUnknownNode >> dependencies [
	^ #()
]

{ #category : #printing }
GtRlUnknownNode >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]
