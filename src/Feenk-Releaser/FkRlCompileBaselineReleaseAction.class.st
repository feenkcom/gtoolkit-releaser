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

{ #category : #printing }
FkRlCompileBaselineReleaseAction >> description [
	^ 'Compile baseline ', self projectReleases project baselineClass name
]

{ #category : #printing }
FkRlCompileBaselineReleaseAction >> descriptionDetails [
	^ self projectReleases project baselineClass name
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> name [ 	
	^ 'Compile baseline'
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> projectReleases [
	^ projectReleases
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> projectReleases: aProjectRelease [
	projectReleases := aProjectRelease
]

{ #category : #accessing }
FkRlCompileBaselineReleaseAction >> repositoryRelease [
	^ self projectReleases repositoryRelease
]
