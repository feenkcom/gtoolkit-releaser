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
			|theList|
			theList := pspec spec projectReference repositories list.
			theList ifNotEmpty: [  
				url := pspec spec projectReference repositories list first name.
				(url beginsWith: 'github')
					ifTrue: [ self getProject: pspec name fromRepository: url ];
					ifFalse: [ Transcript crTrace: url ] ]].
]

{ #category : #releasing }
GtRlRepositoriesCloner class >> loadProject: aBaselineClassName fromRepository: aRepositoryUrl [
	|repos loadWarnings projectBuilder project release config |
	self getProject: aBaselineClassName fromRepository: aRepositoryUrl.
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: (('BaselineOf',aBaselineClassName) asClass)
		withRepositoryDescription: aRepositoryUrl.
	config := GtRlReleaseConfiguration new defaultReleaseStrategy: GtRlNullReleaseStrategy new.
	release := GtRlReleaseBuilder new configuration: config;
		buildReleaseForProject: project.
	repos := GtRlReleaseOrderTraversal new releaseOrderFor: release repositoryRelease.
	loadWarnings := OrderedCollection new.
	(repos flatCollect: [:r | r projectReleases]) 
		collect: [ :pr |
			Metacello new
				baseline: pr name;
				repository: pr repositoryRelease repository url asString;
				silently;
				onConflictUseIncoming;
				 onWarning: [ :anException |
					"Log the error now."
					MetacelloNotification signal: anException description.
					"Create a list of all warnings."
					loadWarnings add: anException description.
					
					anException resume ];
				load].
		
	"In case there are warnings during the loading fail here.
	Otherwise most likely the failure will happen only when 
	running tests or when running releaser."
	loadWarnings ifNotEmpty: [  
		Error signal: (String streamContents: [ :aStream |
			aStream nextPutAll: 'Warnings detected during loading: '.
			aStream nextPutAll: OSPlatform current lineEnding.
			loadWarnings 
				asStringOn: aStream 
				delimiter: OSPlatform current lineEnding ]) ].
]
