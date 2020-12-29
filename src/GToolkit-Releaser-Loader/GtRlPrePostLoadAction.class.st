Class {
	#name : #GtRlPrePostLoadAction,
	#superclass : #GtRlProjectLoadDirectiveAction,
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #accessing }
GtRlPrePostLoadAction >> actionSelector [
	self subclassResponsibility
]

{ #category : #printing }
GtRlPrePostLoadAction >> descriptionDetails [
	^ self actionSelector
]

{ #category : #actions }
GtRlPrePostLoadAction >> performAction [ 
	self assert: [ self actionSelector notNil ].
	
	self loadDirective project baselineClass new 
		perform: self actionSelector
]

{ #category : #printing }
GtRlPrePostLoadAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self actionSelector;
		nextPutAll: ',';
		nextPutAll: self loadDirective projectName;
		nextPutAll: ')'
		
]
