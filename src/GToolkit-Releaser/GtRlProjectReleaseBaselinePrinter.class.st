"
A printer that generates the source code of a baseline for a {{gtClass:GtRlProjectRelease}} instance.

It used the child releases defined with the project release to specify baseline dependencies.
The rest of the information, like packages, is taken from the project associated with the project release.
"
Class {
	#name : #GtRlProjectReleaseBaselinePrinter,
	#superclass : #GtRlBaselinePrinter,
	#instVars : [
		'projectRelease'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlProjectReleaseBaselinePrinter class >> forProjectRelease: aProjectReleasee [
	^ self new
		projectRelease: aProjectReleasee
]

{ #category : #baselines }
GtRlProjectReleaseBaselinePrinter >> baselineProject [
	^ projectRelease project
]

{ #category : #api }
GtRlProjectReleaseBaselinePrinter >> generateProjectDependenciesOn: aStream [
	projectRelease childReleases do: [ :aProjectRelease |
		aStream 
			projectDependencyFor: aProjectRelease name
			withLoadSpec: aProjectRelease repositoryRelease urlWithReleaseVersion asString ].
]

{ #category : #testing }
GtRlProjectReleaseBaselinePrinter >> hasProjectDependencies [
	^ projectRelease childReleases notEmpty
]

{ #category : #accessing }
GtRlProjectReleaseBaselinePrinter >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: self baselineProject name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlProjectReleaseBaselinePrinter >> projectRelease: aProjectRelease [
	projectRelease := aProjectRelease
]
