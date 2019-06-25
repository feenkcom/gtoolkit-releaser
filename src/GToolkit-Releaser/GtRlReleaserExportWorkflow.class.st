"
I execute all release actions for a given release.

I exist to provide an API for inspecting and executing release actions. My main methods for accessing release actions are:
- ${method:GtRlReleaserExportWorkflow>>#releaseActions}$: Returns the complete list of release actions;
- ${method:GtRlReleaserExportWorkflow>>#releaseCreationActions}$: Returns only the actions executed to create the release;
- ${method:GtRlReleaserExportWorkflow>>#releasePostCreationActions}$: Returns the actions that should be executed after the release has been completed.

My main API method for executing release actions is ${method:GtRlReleaserExportWorkflow>>#executeReleaseActions}$.
I rely on the order attribute of release actions to determing the order in which to execute them. 
"
Class {
	#name : #GtRlReleaserExportWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootProjectRelease',
		'releaseActions'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> buildGToolkitRelease [
	| releaseConfiguration workflow | 
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	releaseConfiguration emit.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: BaselineOfGToolkit 
		fromRepository: 'github://feenkcom/gtoolkit/src'
		withConfiguration: releaseConfiguration.
	^ workflow
]

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> buildGToolkitRelease: version [
	| releaseConfiguration workflow |
	TranscriptLogger runDuring: [  
		releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
		releaseConfiguration enforcedVersion: version.
		releaseConfiguration forceNewRelease.
		releaseConfiguration emit.
		workflow := GtRlReleaserExportWorkflow 
			forBaseline: BaselineOfGToolkit 
			fromRepository: 'github://feenkcom/gtoolkit/src'
			withConfiguration: releaseConfiguration.
	].
	^ workflow
]

{ #category : #'instance creation' }
GtRlReleaserExportWorkflow class >> forBaseline: aBaselineClass fromRepository: aRepositoryUrl withConfiguration: aReleaseConfiguration [
	| projectBuilder releaseBuilder project release |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: aBaselineClass
		withRepositoryDescription: aRepositoryUrl.

	releaseBuilder := GtRlReleaseBuilder new
		configuration: aReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: project.
	^ self new
		rootProjectRelease: release
]

{ #category : #'instance creation' }
GtRlReleaserExportWorkflow class >> forProject: aProject withConfiguration: aReleaseConfiguration [
	| releaseBuilder release |
	releaseBuilder := GtRlReleaseBuilder new
		configuration: aReleaseConfiguration. 
	release := releaseBuilder buildReleaseForProject: aProject.
	^ self new
		rootProjectRelease: release
]

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> gtoolkitReleaseConfiguration [
	^ GtRlReleaseConfiguration new
	defaultVersionNumber: (GtRlSemanticVersionNumber major:0 minor: 6 patch: 0);
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new;	
	setReleaseStrategyOfType: GtRlLeafProjectReleaseStrategy forProjecs: {
		'github://feenkcom/gtoolkit-releaser/src' };
	setReleaseStrategyOfType: GtRlHeadCommitReleaseStrategy forProjecs: {
		'github://kursjan/petitparser2'.
		'github://j-brant/SmaCC/src'.
		'github://feenkcom/pharo-beacon/repository'.
		'github://svenvc/NeoJSON/repository'.
		'github://pharo-contributions/CollectionExtensions/src'};
	setReleaseStrategyOfType: GtRlBaselineTagReleaseStrategy forProjecs: {
		'github://noha/mustache/repository'.
		'github://sbragagnolo/taskit'.
		'github://feenkcom/Containers-PropertyEnvironment'.
		'github://feenkcom/Chrysal/src' }
]

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> performGToolkitRelease [
	| workflow |
	workflow := self buildGToolkitRelease.
	^ workflow executeReleaseActions.
]

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> switchAllRepositoriesBackToMasterBranch [
	((IceRepository registry select: [ :repo | (LGitRepository on: repo location) 
		repositoryReference isNotNil ]) 
			select: [ :repo | repo head name = 'release' ]) 
				do: [ :repo | repo checkoutBranch: 'master' ].

	((IceRepository registry select: [ :repo | (LGitRepository on: repo location) 
		repositoryReference isNotNil ]) 
			select: [ :repo | repo head name = 'master' ]) do: [ :repo | repo branch hasUpstream ifTrue: [repo pull ]].
]

{ #category : #actions }
GtRlReleaserExportWorkflow >> executeReleaseActions [
	self releaseCreationActions execute.
	self releasePostCreationActions execute.
	^ self
	
]

{ #category : #ui }
GtRlReleaserExportWorkflow >> gtProjectMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease gtProjectMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserExportWorkflow >> gtRepoMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease repositoryRelease gtRepoMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserExportWorkflow >> gtRepositoryReleasesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releases' translated;
		items: [ self repositoriesReleasesInReleaseOrder ];
		column: 'Repository' item: [ :aRepositoryRelease | 
			aRepositoryRelease decorateText: aRepositoryRelease repository id ];
		column: 'Version' item: [ :aRepositoryRelease | 
			aRepositoryRelease decorateText: aRepositoryRelease version description ];
		column: 'Release strategy' item: [ :aRepositoryRelease | 
			aRepositoryRelease decorateText: aRepositoryRelease releaseStrategy description ]
]

{ #category : #ui }
GtRlReleaserExportWorkflow >> gtViewPostCreationActionsFor: aView [
	<gtView>
	^ (self releasePostCreationActions gtReleaseActionsFor: aView)
		title: 'Post actions' translated;
		priority: 55
]

{ #category : #ui }
GtRlReleaserExportWorkflow >> gtViewReleaseCreationActionsFor: aView [
	<gtView>
	^ (self releaseCreationActions gtReleaseActionsFor: aView)
		title: 'Creation actions' translated;
		priority: 50
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> releaseActions [
	^ releaseActions
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> releaseCreationActions [
	^ self releaseActions reject: [ :action | action class = GtRlPushToOriginReleaseAction ]
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> releasePostCreationActions [
	^ self releaseActions select: [ :action | action class = GtRlPushToOriginReleaseAction ]
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> repositoriesReleasesInReleaseOrder [
	^ GtRlReleaseOrderTraversal new releaseOrderFor: self rootProjectRelease repositoryRelease
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> rootProjectRelease [
	^ rootProjectRelease
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> rootProjectRelease: aProjectRelease [
	rootProjectRelease := aProjectRelease.
	self updateReleaseActions.
]

{ #category : #private }
GtRlReleaserExportWorkflow >> updateReleaseActions [
	releaseActions := GtRlReleaseActionsGroup new.
	self rootProjectRelease repositoryRelease 
		withDeep: #childRepositoryReleases 
		do: [ :aRepositoryRelease |
			releaseActions addActions: aRepositoryRelease releaseActions.
			aRepositoryRelease projectReleases do: [ :aProjectRelease |
				 releaseActions addActions: aProjectRelease releaseActions ] ].
	releaseActions := releaseActions sortedByOrder.
]
