Class {
	#name : #FkRlDedicatedReleaseBranchStragegy,
	#superclass : #FkRlReleaseStragegy,
	#instVars : [
		'referenceBranchName',
		'releaseBranchName'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #actions }
FkRlDedicatedReleaseBranchStragegy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self releaseBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #actions }
FkRlDedicatedReleaseBranchStragegy >> mergeToReleaseBranch [
	| icebergRepository |
	icebergRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ icebergRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the reference branch.'.
	self repositoryRelease mergeToBranch: self releaseBranchName
]

{ #category : #accessing }
FkRlDedicatedReleaseBranchStragegy >> referenceBranchName [
	^ referenceBranchName
]

{ #category : #accessing }
FkRlDedicatedReleaseBranchStragegy >> referenceBranchName: aBranchName [
	referenceBranchName := aBranchName
]

{ #category : #accessing }
FkRlDedicatedReleaseBranchStragegy >> releaseBranchName [
	^ releaseBranchName
]

{ #category : #accessing }
FkRlDedicatedReleaseBranchStragegy >> releaseBranchName: aBranchName [
	releaseBranchName := aBranchName
]

{ #category : #accessing }
FkRlDedicatedReleaseBranchStragegy >> releaseTarget [
	^ '#', self releaseBranchName
]
