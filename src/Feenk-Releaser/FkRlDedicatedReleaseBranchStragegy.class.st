Class {
	#name : #FkRlDedicatedReleaseBranchStragegy,
	#superclass : #FkRlReleaseStragegy,
	#instVars : [
		'referenceBranchName',
		'releaseBranchName'
	],
	#category : #'Feenk-Releaser'
}

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

{ #category : #'as yet unclassified' }
FkRlDedicatedReleaseBranchStragegy >> releaseTarget [
	^ '#', self releaseBranchName
]
