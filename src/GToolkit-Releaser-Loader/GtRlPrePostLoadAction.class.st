Class {
	#name : 'GtRlPrePostLoadAction',
	#superclass : 'GtRlProjectLoadDirectiveAction',
	#category : 'GToolkit-Releaser-Loader'
}

{ #category : 'accessing' }
GtRlPrePostLoadAction >> actionSelector [
	self subclassResponsibility
]

{ #category : 'printing' }
GtRlPrePostLoadAction >> descriptionDetails [
	^ self actionSelector
]

{ #category : 'accessing' }
GtRlPrePostLoadAction >> gtViewCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Method';
		object: [ self loadDirective project baselineClass >> self actionSelector ];
		view: #gtSourceFor:
]

{ #category : 'actions' }
GtRlPrePostLoadAction >> performAction [ 
	self assert: [ self actionSelector notNil ].
	
	self loadDirective project baselineClass new 
		perform: self actionSelector 
		withEnoughArguments: { nil }
]

{ #category : 'printing' }
GtRlPrePostLoadAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self actionSelector;
		nextPutAll: ',';
		nextPutAll: self loadDirective projectName;
		nextPutAll: ')'
		
]
