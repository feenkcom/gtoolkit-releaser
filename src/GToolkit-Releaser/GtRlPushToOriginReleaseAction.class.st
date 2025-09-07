"
I execute a push to the remote branch associated with the local release branch. I should only be called if there is a way to determine a remote branch where to do the push. See {{gtMethod:GtRlPushToOriginReleaseAction>>#performAction}} for more details about my preconditions and implementation details.


"
Class {
	#name : #GtRlPushToOriginReleaseAction,
	#superclass : #GtRlRepositoryReleaseAction,
	#category : #'GToolkit-Releaser'
}

{ #category : #printing }
GtRlPushToOriginReleaseAction >> description [
	^ 'Push to origin release branch ',
		'#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
GtRlPushToOriginReleaseAction >> descriptionDetails [
	^ 'Push ', '#', self repositoryRelease releaseStrategy releaseBranchName
]

{ #category : #printing }
GtRlPushToOriginReleaseAction >> name [ 
	^ 'Push to origin'
]

{ #category : #actions }
GtRlPushToOriginReleaseAction >> performAction [
	| branch remote |
	branch := self repositoryRelease icebergRepository branch.
	self 
		assert: [ self repositoryRelease icebergRepository branchName = self repositoryRelease releaseStrategy releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self 
		assert: [ branch hasUpstream or: [ self repositoryRelease hasRemoteOrigin ] ]
		description: 'The release branch or the Iceberg repository need to have a remove origin where to push the release.'.
	
	remote := branch hasUpstream
		ifTrue: [ branch upstream remote ]
		ifFalse: [ self repositoryRelease remoteOrigin ].
		
	self repositoryRelease icebergRepository branch pushTo: remote. 
	
	"Does not work due to exception"
	"self repositoryRelease releaseStrategy releaseBranch pushTo: remote"
]
