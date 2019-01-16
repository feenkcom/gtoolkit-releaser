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
	TranscriptLogger runDuring: [  
		releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
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
	projectBuilder := GtRlModelBuilder new.
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
	defaultVersionNumber: (GtRlSemanticVersionNumber major:0 minor: 4 patch: 0);
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new;	
	setReleaseStrategyOfType: GtRlLeafProjectReleaseStrategy forProjecs: {
		'github://feenkcom/gtoolkit-releaser/src' };
	setReleaseStrategyOfType: GtRlLatestCommitReleaseStrategy forProjecs: {
		'github://kursjan/petitparser2'.
		'github://j-brant/SmaCC/src'.
		'github://pharo-project/pharo-beacon/repository'.
		'github://svenvc/NeoJSON/repository'};
	setReleaseStrategyOfType: GtRlLoadedTagReleaseStrategy forProjecs: {
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

{ #category : #actions }
GtRlReleaserExportWorkflow >> executeReleaseActions [
	^ self releaseActions execute
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
GtRlReleaserExportWorkflow >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
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

{ #category : #accessing }
GtRlReleaserExportWorkflow >> releaseActions [
	^ releaseActions
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
