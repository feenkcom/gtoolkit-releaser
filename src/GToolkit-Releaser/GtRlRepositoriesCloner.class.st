Class {
	#name : #GtRlRepositoriesCloner,
	#superclass : #Object,
	#category : #'GToolkit-Releaser'
}

{ #category : #releasing }
GtRlRepositoriesCloner class >> getProject: projectName fromRepository: repoURL [
	| project url |
	project := (Metacello new
		baseline: projectName;
		repository: repoURL;
		get) roots first.
	(project version spec packages list
		select: [ :spec | spec spec class = MetacelloProjectReferenceSpec ])
		collect: [ :pspec | 
			url := pspec spec projectReference repositories list first name.
			(url beginsWith: 'github')
				ifTrue: [ self getProject: pspec name fromRepository: url ];
				ifFalse: [ Transcript crTrace: url ] ]
]
