Extension { #name : #BaselineOf }

{ #category : #'*GToolkit-Releaser-BaselineModel' }
BaselineOf class >> gtRlProjectWithRepository: aRepositoryUrl [
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: self
		withRepositoryDescription: aRepositoryUrl.
	^ project
]
