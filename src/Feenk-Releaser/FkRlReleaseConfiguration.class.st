Class {
	#name : #FkRlReleaseConfiguration,
	#superclass : #Object,
	#instVars : [
		'defaultReleaseBranchName',
		'nextVersionComputation',
		'customReleaseBranches',
		'ignoredProjects'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlReleaseConfiguration >> customReleaseBranches [
	^ customReleaseBranches ifNil: [ 
		customReleaseBranches := Dictionary new ]
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultReleaseBranchName [
	^ defaultReleaseBranchName
]

{ #category : #accessing }
FkRlReleaseConfiguration >> defaultReleaseBranchName: aBranchName [
	defaultReleaseBranchName := aBranchName
]

{ #category : #actions }
FkRlReleaseConfiguration >> ignoreProject: aProjectId [
	self ignoredProjects add: aProjectId
]

{ #category : #accessing }
FkRlReleaseConfiguration >> ignoredProjects [
	^ ignoredProjects ifNil: [ 
		ignoredProjects := OrderedCollection new ]
]

{ #category : #accessing }
FkRlReleaseConfiguration >> nextVersionComputation [
	^ nextVersionComputation
]

{ #category : #accessing }
FkRlReleaseConfiguration >> nextVersionComputation: aVersionComputation [
	nextVersionComputation := aVersionComputation
]

{ #category : #actions }
FkRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]
