Class {
	#name : #GtRlCompileBaselineReleaseAction,
	#superclass : #GtRlReleaseAction,
	#instVars : [
		'projectReleases'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlCompileBaselineReleaseAction class >> forProjectRelease: aProjectRelease [
	^ self new
		projectReleases: aProjectRelease
]

{ #category : #printing }
GtRlCompileBaselineReleaseAction >> description [
	^ 'Compile baseline ', self projectReleases project baselineClass name
]

{ #category : #printing }
GtRlCompileBaselineReleaseAction >> descriptionDetails [
	^ self projectReleases project baselineClass name
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> name [ 	
	^ 'Compile baseline'
]

{ #category : #actions }
GtRlCompileBaselineReleaseAction >> performAction [
	self projectReleases compileBaselineMethod
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> projectReleases [
	^ projectReleases
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> projectReleases: aProjectRelease [
	projectReleases := aProjectRelease
]

{ #category : #accessing }
GtRlCompileBaselineReleaseAction >> repositoryRelease [
	^ self projectReleases repositoryRelease
]
