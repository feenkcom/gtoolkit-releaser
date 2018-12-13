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
	self 
		assert: [ self repositoryRelease hasRemoteOrigin ]
		description: 'The Iceberg repository needs to have a remove origin where to push the release.'.
	self repositoryRelease releaseStrategy releaseBranch pushTo: self repositoryRelease remoteOrigin
]
