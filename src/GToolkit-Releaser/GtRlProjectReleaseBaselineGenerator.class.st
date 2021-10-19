"
A printer that generates the source code of a baseline for a {{gtClass:GtRlProjectRelease}} instance.

It used the child releases defined with the project release to specify baseline dependencies.
The rest of the information, like packages, is taken from the project associated with the project release.
"
Class {
	#name : #GtRlProjectReleaseBaselineGenerator,
	#superclass : #GtRlBaselineGenerator,
	#instVars : [
		'projectRelease'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlProjectReleaseBaselineGenerator class >> forProjectRelease: aProjectReleasee [
	^ self new
		projectRelease: aProjectReleasee
]

{ #category : #baselines }
GtRlProjectReleaseBaselineGenerator >> baselineProject [
	^ projectRelease project
]

{ #category : #api }
GtRlProjectReleaseBaselineGenerator >> generateProjectDependenciesOn: aStream [
	projectRelease childReleases do: [ :aProjectRelease |
		aStream 
			projectDependencyFor: aProjectRelease name
			withLoadSpec: aProjectRelease repositoryRelease urlWithReleaseVersion asString ].
]

{ #category : #testing }
GtRlProjectReleaseBaselineGenerator >> hasProjectDependencies [
	^ projectRelease childReleases notEmpty
]

{ #category : #accessing }
GtRlProjectReleaseBaselineGenerator >> projectRelease: aProjectRelease [
	projectRelease := aProjectRelease
]
