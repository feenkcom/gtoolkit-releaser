"
I traverse a structure of repository releases and return them in the order in which they should be updated.

Releases should be updated starting with all the children of a parent release, before updating the parent. Also a release should be updated only once. The children should be updated first so update their version. Then the parent can check whether or not its children have new versions.

I assume that the release has no cycles between repositories. I use {{gtClass:GtRlReleaseTraversalContext}} to detect cycles and trigger an error in case a cycles between repositories is found.


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
	traversalContext := GtRlReleaseTraversalContext new.
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
	
	traversalContext 
		withRecursionDetectionFor: aRepositoryRelease
		during: [ 
			aRepositoryRelease childRepositoryReleases do: [ :aChildRelease | 
				self releaseOrderFor: aChildRelease in: currentReleases ].
			"The same repository release can be a child of multiple other repository releases.
			When building the release order we only take it into account the first time we encouter it,
			since we process repositories usign depth first stragegy."
			(currentReleases includes: aRepositoryRelease) ifFalse: [
				currentReleases add: aRepositoryRelease ] ]
	
	

]
