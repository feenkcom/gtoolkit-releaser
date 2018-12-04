Class {
	#name : #GtRlDedicatedReleaseBranchStragegy,
	#superclass : #GtRlReleaseStragegy,
	#instVars : [
		'referenceBranchName',
		'releaseBranchName'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #actions }
GtRlDedicatedReleaseBranchStragegy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #actions }
GtRlDedicatedReleaseBranchStragegy >> mergeToReleaseBranch [
	| icebergRepository |
	icebergRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> referenceBranchName [
	^ referenceBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> referenceBranchName: aBranchName [
	referenceBranchName := aBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> releaseBranchName [
	^ releaseBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> releaseBranchName: aBranchName [
	releaseBranchName := aBranchName
]

{ #category : #accessing }
GtRlDedicatedReleaseBranchStragegy >> releaseTarget [
	^ '#', self releaseBranchName
]
