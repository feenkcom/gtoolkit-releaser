"
I am an abstraction for entities within a project loading configuration for which a new relese version can be generated.

I hold a list of actions that are executed in order to generate a new release version. Subclasses are responsible with generating the list of actions, updating it if necessary or executing it.


"
Class {
	#name : #GtRlRelease,
	#superclass : #Object,
	#instVars : [
		'releaseActions'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlRelease >> addReleaseAction: aReleaseAction [
	aReleaseAction emitCreationSignal.
	^ self releaseActions addAction: aReleaseAction
]

{ #category : #ui }
GtRlRelease >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #testing }
GtRlRelease >> hasReleaseActions [ 
	^ self releaseActions isEmpty not
]

{ #category : #accessing }
GtRlRelease >> nodeName [
	self subclassResponsibility
]

{ #category : #accessing }
GtRlRelease >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := GtRlReleaseActionsGroup new ]
]

{ #category : #actions }
GtRlRelease >> resetReleaseActions [
	self releaseActions removeAll.
]
