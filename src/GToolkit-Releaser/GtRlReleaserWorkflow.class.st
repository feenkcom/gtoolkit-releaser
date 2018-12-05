Class {
	#name : #GtRlReleaserWorkflow,
	#superclass : #Object,
	#instVars : [
		'rootProjectRelease',
		'releaseActions'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlReleaserWorkflow class >> forBaseline: aBaselineClass fromRepository: aRepositoryUrl withConfiguration: aReleaseConfiguration [
	| projectBuilder releaseBuilder project release |
	projectBuilder := GtRlModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: aBaselineClass
		withRepositoryDescription: aRepositoryUrl.

	releaseBuilder := GtRlReleaseBuilder new
		configuration: aReleaseConfiguration. 
	release := releaseBuilder buildReleaseForPoject: project.
	^ self new
		rootProjectRelease: release
]

{ #category : #releasing }
GtRlReleaserWorkflow class >> gtoolkitReleaseConfiguration [
	^ GtRlReleaseConfiguration new
	defaultReleaseBranchName: 'release';
	defaultVersionComputation: GtRlPatchVersionComputation new;	
	setVersionComputationOfType: GtRlLatestCommitComputation forProjecs: {
		'github://kursjan/petitparser2'.
		'github://j-brant/SmaCC/src'.
		'github://pharo-project/pharo-beacon/repository'.
		'github://svenvc/NeoJSON/repository' };
	setVersionComputationOfType: GtRlCurrentLoadedTagComputation forProjecs: {
		'github://noha/mustache/repository'.
		'github://sbragagnolo/taskit' };
	ignoreProjects: {
		'github://kursjan/petitparser2'.
		'github://j-brant/SmaCC/src'.
		'github://pharo-project/pharo-beacon/repository'.
		'github://svenvc/NeoJSON/repository'.
		'github://noha/mustache/repository'.
		'github://sbragagnolo/taskit' }
]

{ #category : #releasing }
GtRlReleaserWorkflow class >> performGToolkitRelease [
	| releaseConfiguration workflow |
	releaseConfiguration := GtRlReleaserWorkflow gtoolkitReleaseConfiguration.
	workflow := GtRlReleaserWorkflow 
		forBaseline: BaselineOfGToolkit 
		fromRepository: 'github://feenkcom/gtoolkit/src'
		withConfiguration: releaseConfiguration.
	^ workflow executeReleaseActions.
]

{ #category : #actions }
GtRlReleaserWorkflow >> createReleaseActions [
	| order newReleaseActions |
	order := 0.
	newReleaseActions := GtRlReleaseActionsGroup new.
	self repositoriesReleasesInReleaseOrder do: [ :aRepositoryRelease |
		|  mergeAction commitAction |
		mergeAction := GtRlMergeToReleaseBranchAction forRepositoryRelease: aRepositoryRelease.
		mergeAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: mergeAction.
		newReleaseActions addAction: mergeAction.
		(aRepositoryRelease projectReleases reject: #isLeaf) do: [ :aProjectRelease | 
			| baselineAction |
			baselineAction := GtRlCompileBaselineReleaseAction forProjectRelease: aProjectRelease.
			baselineAction order: (order := order + 1).
			aProjectRelease addReleaseAction: baselineAction.
			newReleaseActions addAction: baselineAction ].
		commitAction := GtRlCommitAndTagReleaseAction forRepositoryRelease: aRepositoryRelease.
		commitAction order: (order := order + 1).
		aRepositoryRelease addReleaseAction: commitAction.
		newReleaseActions addAction: commitAction ].
	^ newReleaseActions
	
]

{ #category : #actions }
GtRlReleaserWorkflow >> executeReleaseActions [
	^ self releaseActions execute
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtProjectMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease gtProjectMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtReleaseActionsFor: aView [
	<gtView>
	^ self releaseActions gtReleaseActionsFor: aView
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtRepoMapFor: aView [
	<gtView>
	^ self rootProjectRelease 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | 
			rootProjectRelease repositoryRelease gtRepoMapFor: aView ]
]

{ #category : #ui }
GtRlReleaserWorkflow >> gtRepositoryReleasesListFor: aView [
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
GtRlReleaserWorkflow >> releaseActions [
	^ releaseActions ifNil: [ 
		releaseActions := self createReleaseActions ]
]

{ #category : #accessing }
GtRlReleaserWorkflow >> repositoriesReleasesInReleaseOrder [
	^ self rootProjectRelease repositoryRelease allChildRepositoryReleases reverse reject: [ :aRelease |
		aRelease isPassiveRelease ]
]

{ #category : #accessing }
GtRlReleaserWorkflow >> rootProjectRelease [
	^ rootProjectRelease
]

{ #category : #accessing }
GtRlReleaserWorkflow >> rootProjectRelease: aProjectRelease [
	rootProjectRelease := aProjectRelease
]
