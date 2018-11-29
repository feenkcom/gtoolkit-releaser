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

{ #category : #actions }
FkRlReleaseConfiguration >> ignoreProjects: aColectionOfProjectsIds [
	self ignoredProjects addAll: aColectionOfProjectsIds
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

{ #category : #'accessing - dynamic' }
FkRlReleaseConfiguration >> releaseBranchForRepository: aRepository [
	^ self customReleaseBranches 
		at: aRepository id 
		ifAbsent: [ self defaultReleaseBranchName ]
]

{ #category : #actions }
FkRlReleaseConfiguration >> setReleaseBranch: aBranchName forProjectId: aProjectId [
	self customReleaseBranches 
		at: aProjectId put: aBranchName
]
