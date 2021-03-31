"
I provide recursion detection when traversing repository releases.

My users should use ${method:GtRlReleaseTraversalContext>>#withRecursionDetectionFor:during:}$ to nest each step of the traversal. This method registers the given repository release and triggers an error in case the same repository release is encountered a second time in a nested step.

An an implementation, I use a ${class:Stack}$ to maintain the current chain of repository releases, and pop/push repositories from this stack during traversal.
"
Class {
	#name : #GtRlReleaseTraversalContext,
	#superclass : #Object,
	#instVars : [
		'repositoriesChain'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #utils }
GtRlReleaseTraversalContext >> ensureNoRecursioErrorFor: aRepositoryRelease [
	(self repositoriesChain includes: aRepositoryRelease) ifTrue:
		[ self error: 'Circular dependency to repository: ', aRepositoryRelease printString ].
]

{ #category : #initialization }
GtRlReleaseTraversalContext >> initialize [
	super initialize.
	repositoriesChain := Stack new.
]

{ #category : #utils }
GtRlReleaseTraversalContext >> popRepository: aRepositoryRelease [
	| removedRepository |
	removedRepository := self repositoriesChain pop.
	self assert: [ removedRepository == aRepositoryRelease ].
]

{ #category : #utils }
GtRlReleaseTraversalContext >> pushRepository: aRepositoryRelease [
	self repositoriesChain push: aRepositoryRelease.
]

{ #category : #accessing }
GtRlReleaseTraversalContext >> repositoriesChain [
	^ repositoriesChain
]

{ #category : #actions }
GtRlReleaseTraversalContext >> withRecursionDetectionFor: aRepositoryRelease during: aBlock [
	"Perform the given block and ensure the given repository release is not in the current chain of repositories.
	Trigger a recursion error in case the given repository release is found in the current chain.
	The given repository release is in the current chain only during the execution of this method."
	
	self ensureNoRecursioErrorFor: aRepositoryRelease.
	self pushRepository: aRepositoryRelease.
	
	aBlock value.
	
	self popRepository: aRepositoryRelease.
]
