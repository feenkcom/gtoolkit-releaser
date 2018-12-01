Class {
	#name : #FkRlCompileBaselineReleaseAction,
	#superclass : #FkRlReleaseAction,
	#instVars : [
		'projectReleases'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #'instance creation' }
FkRlCompileBaselineReleaseAction class >> forProjectRelease: aProjectRelease [
	^ self new
		projectReleases: aProjectRelease
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> projectReleases [
	^ projectReleases
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> projectReleases: aProjectRelease [
	projectReleases := aProjectRelease
]
