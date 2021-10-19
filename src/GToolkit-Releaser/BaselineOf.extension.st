Extension { #name : #BaselineOf }

{ #category : #'*GToolkit-Releaser' }
BaselineOf class >> gtRlProjectReleaseWithRepository: aRepositoryUrl withConfiguration: aReleaseConfiguration [
	| releaseBuilder project |
	project := self gtRlProjectWithRepository: aRepositoryUrl.
	releaseBuilder := GtRlReleaseBuilder new
		configuration: aReleaseConfiguration. 
	^ releaseBuilder buildReleaseForProject: project.
]
