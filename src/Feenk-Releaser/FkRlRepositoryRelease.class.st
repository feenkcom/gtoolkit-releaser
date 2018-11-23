Class {
	#name : #FkRlRepositoryRelease,
	#superclass : #FkRlRelease,
	#instVars : [
		'repository',
		'projectReleases'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #ui }
FkRlRepositoryRelease >> gtProjectsFor: aView [
	<gtView>
	^ aView list 
		title: 'Project releases' translated;
		items: [ self projectReleases ]
]

{ #category : #printing }
FkRlRepositoryRelease >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self repository urlString;
		nextPutAll: ', ';
		nextPutAll: self semanticVersion versionString;
		nextPutAll: ')'
]

{ #category : #accessing }
FkRlRepositoryRelease >> projectReleases [ 	
	^ projectReleases ifNil: [ 
		projectReleases := self repository projects collect: [ :aProject |
			FkRlProjectRelease new
				project: aProject;
				branchName: self branchName;
				semanticVersion: self semanticVersion ] ]
]

{ #category : #accessing }
FkRlRepositoryRelease >> repository [
	^ repository 
]

{ #category : #accessing }
FkRlRepositoryRelease >> repository: aRepository [
	repository := aRepository
]
