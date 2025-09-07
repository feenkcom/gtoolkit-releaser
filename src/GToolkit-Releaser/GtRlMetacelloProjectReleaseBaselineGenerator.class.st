Class {
	#name : #GtRlMetacelloProjectReleaseBaselineGenerator,
	#superclass : #GtRlMetacelloBaselineGenerator,
	#instVars : [
		'projectRelease'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlMetacelloProjectReleaseBaselineGenerator class >> forProjectRelease: aProjectReleasee [
	^ self new
		projectRelease: aProjectReleasee
]

{ #category : #baselines }
GtRlMetacelloProjectReleaseBaselineGenerator >> baselineProject [
	^ projectRelease project
]

{ #category : #'accessing - dynamic' }
GtRlMetacelloProjectReleaseBaselineGenerator >> childProjectsWithRepositoryURL [
	^ projectRelease childReleases collect: [ :aRelease |
		aRelease project name -> {aRelease repositoryRelease urlWithReleaseVersion asString} ]
]

{ #category : #accessing }
GtRlMetacelloProjectReleaseBaselineGenerator >> projectRelease: anObject [
	projectRelease := anObject
]
