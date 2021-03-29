"
I traverse a structure of repository releases and return them in the order in which they should be updated.

Releases should be updated starting with all the children of a parent release, before updating the parent. Also a release should be updated only once. The children should be updated first so update their version. Then the parent can check whether or not its children have new versions.
"
Class {
	#name : #GtRlReleaseOrderTraversal,
	#superclass : #Object,
	#instVars : [
		'traversalContext'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #initialization }
GtRlReleaseOrderTraversal >> initialize [
	super initialize.
	traversalContext := Stack new.
]

{ #category : #actions }
GtRlReleaseOrderTraversal >> releaseOrderFor: aRepositoryRelease [ 
	| releasesInReleaseOrder |
	releasesInReleaseOrder := OrderedCollection new.
	self releaseOrderFor: aRepositoryRelease in: releasesInReleaseOrder.
	^ releasesInReleaseOrder
]

{ #category : #private }
GtRlReleaseOrderTraversal >> releaseOrderFor: aRepositoryRelease in: currentReleases [
	"I traverse first the children recursively, and only after all the children are traversed, 
	I add the current release to the list if needed. The release is added to the list only if 
	it is not already present. If its present it means it was already traversed as it was also
	a child of another release."
	
	(traversalContext includes: aRepositoryRelease) ifTrue:
		[ self error: 'Circular dependency to repository: ', aRepositoryRelease printString ].
	traversalContext push: aRepositoryRelease.
	
	aRepositoryRelease childRepositoryReleases do: [ :aChildRelease | 
		self releaseOrderFor: aChildRelease in: currentReleases].
	(currentReleases includes: aRepositoryRelease) ifFalse: [
		currentReleases add: aRepositoryRelease ].
	
	traversalContext pop.
]
