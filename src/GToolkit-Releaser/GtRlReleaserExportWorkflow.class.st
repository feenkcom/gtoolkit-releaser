Class {
	#name : #GtRlReleaserExportWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootProjectRelease',
		'releaseActions'
	],
	#category : #'GToolkit-Releaser'
}

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

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> gtoolkitReleaseConfiguration [
	^ GtRlReleaseConfiguration new
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new;	
	setReleaseStrategyOfType: GtRlLatestCommitReleaseStrategy forProjecs: {
		'github://kursjan/petitparser2'.
		'github://j-brant/SmaCC/src'.
		'github://pharo-project/pharo-beacon/repository'.
		'github://svenvc/NeoJSON/repository'};
	setReleaseStrategyOfType: GtRlBaselineTagReleaseStrategy forProjecs: {
		'github://noha/mustache/repository'.
		'github://sbragagnolo/taskit'.
		'github://feenkcom/Containers-PropertyEnvironment'.
		'github://feenkcom/Chrysal/src' }
]

{ #category : #releasing }
GtRlReleaserExportWorkflow class >> performGToolkitRelease [
	| releaseConfiguration workflow |
	releaseConfiguration := GtRlReleaserExportWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserExportWorkflow 
		forBaseline: BaselineOfGToolkit 
		fromRepository: 'github://feenkcom/gtoolkit/src'
		withConfiguration: releaseConfiguration.
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
		column: 'Repository' item: [ :aRepositoryRelease | aRepositoryRelease repository id ];
		column: 'Version' do: [ :aColumn | 
			aColumn 
				item: #versionString;
				width: 100 ]";
		column: 'Release strategy' item: [ :aRepositoryRelease | aRepositoryRelease releaseStrategy releaseTarget ]"
]

{ #category : #accessing }
GtRlReleaserExportWorkflow >> releaseActions [
	^ releaseActions
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
