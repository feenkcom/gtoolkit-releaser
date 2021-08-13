"
I model a release for a repository by decorating a {{gtClass:GtRlRepository}} instance with a concrete version number.

My main responsability is to store a concrete version number and a release strategy that computes that version number. I do not know how to determine the version number and create the actual list of actions. The release strategy is responsible for computing the version number for the release and creating the list of actions for generating that version number.

I must have a version number and a release strategy, but I can have an empty list of actions. This can happen if the version number already exists. For example, if the version number is a hash of an existing commit that already exists, no further action is necessary. In that case I am a passive release. However, I can turn from a passive release to an active release, or vice versa, if my release strategy is changed.

I have as main attributes:
	- repository: the {{gtClass:GtRlRepository}} for which I do a release;
	- projectReleases: the list of project releases for the projects contained in the repository that I reference. 
	- version: the version number corresponding to this release
	- releaseStrategy: the strategy that creates the actions for generating the release version
	- isPassiveRelease: a flag set when creating the release indicating if the release is passive; If this flag is set no actions will be generated for the project; TODO: ideally I should be removed and a passive release should just be a release that has no actions. I exist due to the way actions are added to a release by a release strategy.
	
I contain the actions that need to be performed at the repository level, like committing code and tags, but I do not model any action at the project level. For that I hold a list of {{gtClass:GtRlProjectRelease}} instances. These correspond to the projects contained in the repository that I reference. 


"
Class {
	#name : #GtRlRepositoryRelease,
	#superclass : #GtRlRelease,
	#instVars : [
		'version',
		'isPassiveRelease',
		'releaseStrategy',
		'repository',
		'projectReleases',
		'newCommits',
		'newCommitsString',
		'isRoot'
	],
	#category : 'GToolkit-Releaser'
}

{ #category : #'instance creation' }
GtRlRepositoryRelease class >> forRepository: aRepository [
	^ self new
		repository: aRepository
]

{ #category : #accessing }
GtRlRepositoryRelease >> addProjectRelease: aProjectRelease [
	aProjectRelease repositoryRelease: self.
	^ self projectReleases add: aProjectRelease
]

{ #category : #ui }
GtRlRepositoryRelease >> allReleaseActions [
	| allActions |
	allActions := self projectReleases 
		inject: self releaseActions
		into: [ :all :current | all, current releaseActions ].
	^ allActions sortedByOrder
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> childRepositoryReleases [
	^ (self projectReleases flatCollect: [ :aProjectRelease | 
		aProjectRelease childReleases collect: #repositoryRelease ]) removeDuplicates
			remove: self ifAbsent: [ ];
			yourself
]

{ #category : #actions }
GtRlRepositoryRelease >> commitAndTagRelease [
	| iceRepository diff |
	iceRepository := self icebergRepository.
	diff := iceRepository workingCopyDiff.
	iceRepository workingCopy 
		commitChanges: diff
		withMessage: self commitMessageForRelease
		force: true.
	iceRepository branch commit ensureCreateTag: self versionString.
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> commitMessageForRelease [
	| localRootProjects |
	
	localRootProjects := self localRootProjects.
	^ String streamContents: [ :stream |
		|commits|
		stream 
			nextPutAll: 'Release version ';
			nextPutAll: self versionString.
		"If more root projects are detected we do not know which one to choose."
		localRootProjects size = 1 ifTrue: [ 
			stream
				lf; lf;
				nextPutAll: 'Metacello new
    baseline: ''', localRootProjects first name, ''';
    repository: ''', self urlWithReleaseVersion asString,  ''';
    load' ; lf.
			self isRootRepositoryRelease ifTrue: [  
				commits := self printNewCommitsToString.
				(commits isNotEmpty) ifTrue: [
					stream
						lf;
						nextPutAll: 'All commits (including upstream repositories) since last build:';
						lf;
						nextPutAll: commits  ] ] ] ]
]

{ #category : #ui }
GtRlRepositoryRelease >> decorateText: aStringOrText [
	^ self isPassiveRelease
		ifTrue: [ aStringOrText asRopedText foreground: Color gray ] 
		ifFalse: [ aStringOrText asRopedText]
]

{ #category : #printing }
GtRlRepositoryRelease >> description [
	^ String streamContents: [ :stream |
		stream 
			nextPutAll: self repository id;
		 	nextPutAll: ', ';
			nextPutAll: self releaseDetailsDescription ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtBaselineVersionMetadataFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Version data' translated;
		priority: 55;
		text: [ STON toJsonStringPretty: self versionsMetadata ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtBranchesFor: aView [
	<gtView>
	^ self repository 
		ifNil: [ aView ]
		ifNotNil: [ :aRepository | aRepository gtBranchesFor: aView ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtCommitsAncestryFor: aView [
	<gtView>
	^ self releaseStrategy 
		ifNil: [ aView ]
		ifNotNil: [ :aReleaseStrategy | 
			(aReleaseStrategy gtCommitsAncestryFor: aView)
				priority: 45 ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtProjectsFor: aView [
	<gtView>
	^ aView list 
		title: 'Project releases' translated;
		priority: 15;
		items: [ self projectReleases ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtReleaseActionsFor: aView [
	<gtView>
	| allActions |
	allActions := self projectReleases 
		inject: self releaseActions
		into: [ :all :current | all, current releaseActions ].
	^ allActions sortedByOrder gtReleaseActionsFor: aView
]

{ #category : #ui }
GtRlRepositoryRelease >> gtReleaseTagsFor: aView [
	<gtView>
	^ aView list
		title: 'Release tags' translated;
		items: [ self semanticVersionTags ];
		itemText: [ :anIceTag | 
			anIceTag name , ' [' , (anIceTag commit id first: 7) , ']' ]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Release Map' translated;
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childRepositoryReleases) asSet.
			mondrian nodes 
				"umlClassShapeWithName: [ :aRepositoryRelease | aRepositoryRelease description ];"
				shape: [ :aRepositoryRelease | |container children label textColor |
					textColor := aRepositoryRelease isPassiveRelease 
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					label := BlTextElement new
						text: (aRepositoryRelease description asRopedText foreground: textColor);
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					children := BlElement new
						constraintsDo: [ :c | 
							c linear horizontal alignCenter ].
					children graph beChildrenContainer.
					container
						addChild: label;
						addChild: children.];
				with: repos;
				forEach: [ :aRepositoryRelease | 
					mondrian nodes
						shape: [ :aProjectRelease ||textColor text|
							textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
								ifTrue: [ Color gray ] ifFalse: [ Color black ].
							text := aProjectRelease project name asRopedText foreground: textColor.
							(BlTextElement text: text)
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c linear horizontal alignCenter ] ];
						with: aRepositoryRelease projectReleases.
						aRepositoryRelease isPassiveRelease ifFalse: [ 
							mondrian nodes
								shape: [ :aReleaseAction |
									|orderContainer|
									orderContainer := BlElement new
									layout: BlLinearLayout horizontal;
									zIndex: 1;
									constraintsDo: [ :c |
										c padding: (BlInsets all: 2).
										c horizontal fitContent.
										c vertical fitContent ].
									orderContainer graph beChildrenContainer.
									orderContainer ];
								with: {aRepositoryRelease};
								forEach: [ :aRepoRelease |
									| text |
									mondrian nodes 
										shape: [ :aReleaseAction | 
											text := aReleaseAction order printString asRopedText.
											(BlTextElement text: text)
												constraintsDo: [ :c | 
													c padding: (BlInsets all: 2)]];
										with: aRepoRelease allReleaseActions actions.
									mondrian layout custom: BlLinearLayout horizontal
									 ]].
					mondrian layout vertical].
			mondrian edges
				shape: [
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.2;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | |dependedRepos |
					dependedRepos := each childRepositoryReleases.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradWestHierarchicalLayout new)]
]

{ #category : #ui }
GtRlRepositoryRelease >> gtRepositoryMapFor: aView [
	<gtView> 
	^ aView explicit
		title: 'Release Graph';
		stencil: [
			| gtconnector options |
			gtconnector := GtConnector new.
			options := GtConnectorOptions new.
			options drawLines: false.
			gtconnector options: options.
			gtconnector stencil: [ :aRepositoryRelease | |container children label textColor |
					textColor := aRepositoryRelease isPassiveRelease 
						ifTrue: [ Color gray ] ifFalse: [ Color black ].
					container := BlElement new
						layout: BlLinearLayout vertical;
						border: (BlBorder paint: Color gray width: 1);
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 5).
							c horizontal fitContent.
							c vertical fitContent ].
					container
						connector 
							model: aRepositoryRelease;
							beLayoutSource; 
							beLayoutTarget;
							beVisualTarget.
					label := BlTextElement new
						text: (aRepositoryRelease description asRopedText foreground: textColor);
						constraintsDo: [ :c | 
							c padding: (BlInsets all: 5).
							c linear horizontal alignCenter ].
					children := BlElement new.
					children	layout: BlLinearLayout vertical.
					children						
						zIndex: 1;
						constraintsDo: [ :c |
							c padding: (BlInsets all: 2).
							c horizontal fitContent.
							c vertical fitContent.
							c linear horizontal alignCenter ].
					container
						addChild: label.
					aRepositoryRelease projectReleases do: [ :aProjectRelease |
						|text vocalProject|
						textColor := (aProjectRelease hasReleaseActions not or: [ aProjectRelease isLeaf ])
								ifTrue: [ Color gray ] ifFalse: [ Color black ].
						text := aProjectRelease project name asRopedText foreground: textColor.
						
						vocalProject := BlElement new.
						vocalProject layout: BlLinearLayout vertical.
						vocalProject constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c horizontal fitContent.
									c vertical fitContent.
									c linear horizontal alignCenter].
						vocalProject addChild: ((BlTextElement text: text)" constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c horizontal fitContent.
									c vertical fitContent]").
						vocalProject connector beVisualSource.
						"aProjectRelease childReleases do: [ :each | 
							each repositoryRelease ~= aRepositoryRelease ifTrue: [
								vocalProject connector addToModelObjectList: each repositoryRelease]]."
						vocalProject when: BlDoubleClickEvent do: [ :event | 
							aProjectRelease childReleases do: [ :each | 
								each repositoryRelease ~= aRepositoryRelease ifTrue: [
									gtconnector addEntity: each repositoryRelease]]].
						children addChild: vocalProject].
				   container addChild: children.
					container].
			gtconnector addEntity: self.
			gtconnector asPannableElement ]
]

{ #category : #testing }
GtRlRepositoryRelease >> hasRemoteOrigin [
	^ self icebergRepository remotes 
		anySatisfy: [ :iceRemote | iceRemote name = #origin ]
		
]

{ #category : #accessing }
GtRlRepositoryRelease >> icebergRepository [
	^ self repository icebergRepository
]

{ #category : #initialize }
GtRlRepositoryRelease >> initialize [
	super initialize.
	isRoot := false.
	self version: GtRlNullVersionNumber new.
	self releaseStrategy: GtRlNullReleaseStrategy new.
]

{ #category : #testing }
GtRlRepositoryRelease >> isPassiveRelease [
	^ isPassiveRelease ifNil: [ true ]
]

{ #category : #accessing }
GtRlRepositoryRelease >> isRootRepositoryRelease [
	^ isRoot
	
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> latestSemanticVersionTag [
	^ ((self icebergRepository tags 
		select: #gtIsSemanticVersion
		thenCollect: [ :anIceTag | 
			anIceTag -> anIceTag gtAsSemanticVersionNumber]) sorted: [ :a :b |
				a value <= b value ]) last key
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> localRootProjects [
	| localRootProjects |
	localRootProjects := self projectReleases select: [ :aProject |
		| allChildren |
		allChildren := aProject withAllChildProjectReleases.
		self projectReleases allSatisfy: [ :anotherProject |
			allChildren includes: anotherProject ] ].
	^ localRootProjects
]

{ #category : #actions }
GtRlRepositoryRelease >> makePassiveRelease [
	self markAsPassive.
	self resetReleaseActions
]

{ #category : #actions }
GtRlRepositoryRelease >> markAsActive [
	isPassiveRelease := false
]

{ #category : #actions }
GtRlRepositoryRelease >> markAsPassive [
	isPassiveRelease := true
]

{ #category : #testing }
GtRlRepositoryRelease >> matchesDependenciesIn: versionMetadata [
	^ (self childRepositoryReleases allSatisfy: [ :aChildRelease |
		versionMetadata matchesVersionForRelease: aChildRelease ]) 
]

{ #category : #actions }
GtRlRepositoryRelease >> mergeToBranch: aBranchName [
	| initialBranchName icebergRepository |
	icebergRepository := self icebergRepository.
	initialBranchName := icebergRepository branchName.
	
	"Switch the release branch. We look for the branch in the remote origin before
	creating the branch locally if there is no release branch locally."
	(icebergRepository hasLocalBranchNamed: aBranchName)
		ifTrue:  [ 
			"In case the release branch is already present locally do a switch."
			(icebergRepository branchNamed: aBranchName) switch. ]
		ifFalse: [ 
			"Look for the release branch in the remote origin."
			icebergRepository 
				remoteBranchNamed: 'origin/', aBranchName
				ifPresent: [ :removeReleseBranch | 
					"If we find a release branch remotely do a switch"
					removeReleseBranch switch ]
				ifAbsent: [
					(icebergRepository createBranch: aBranchName) switch ] ].
	
	"Do the merge from the current branch"
	IceMerge new 
		repository: icebergRepository; 
		mergeCommit: (icebergRepository branchNamed: initialBranchName) commit; 
		executeWithAcceptingLeftOnConflictAndWithoutImageUpdate.
]

{ #category : #accessing }
GtRlRepositoryRelease >> newCommits [
	^ newCommits
]

{ #category : #accessing }
GtRlRepositoryRelease >> newCommits: aListOfCommits [
	newCommits := aListOfCommits
]

{ #category : #printing }
GtRlRepositoryRelease >> nodeName [
	^ self repository id
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> parentRepositoryReleases [
	^ (self projectReleases flatCollect: [ :aProjectRelease | 
		aProjectRelease parentReleases collect: #repositoryRelease ]) removeDuplicates 
			remove: self ifAbsent: [ ];
			yourself
]

{ #category : #actions }
GtRlRepositoryRelease >> printNewCommitsToString [
	|flattenedCommits|
	newCommitsString ifNil: [ 
	newCommitsString :=
	String streamContents: [ :writeStream |
		newCommits := OrderedCollection new.
		flattenedCommits := OrderedCollection new.
		(GtRlReleaseUpdateWorkflow new repositoriesInReleaseOrderFor: self) do: [ :repo |
			|newRepoCommits|
			newRepoCommits := repo releaseStrategy findNewCommits.
			newRepoCommits ifNotNil: [newCommits add: newRepoCommits. 
						flattenedCommits addAll: newRepoCommits newCommits ] ].
			flattenedCommits ifNotEmpty: [  
				newCommits do: [ :aGtRlNewCommits | aGtRlNewCommits newCommits do: [:c |
					|url|
					url := aGtRlNewCommits repository remotes anyOne url.
					url := url replaceSuffix: '.git' with: '/commit/'. 
					url := url copyReplaceAll: 'git@' with: 'https://'.
					url := url copyReplaceAll: 'com:' with: 'com/'.
					writeStream nextPutAll: url.
					writeStream nextPutAll: ((c id asString) first:6).
					writeStream nextPutAll: ' by '.
					writeStream nextPutAll: c author.
					writeStream nextPutAll: (String lf).
					writeStream nextPutAll: (c comment).
					writeStream nextPutAll: (String lf).
					writeStream nextPutAll: (String lf).
					]].
			]
		]].
		^ newCommitsString
]

{ #category : #printing }
GtRlRepositoryRelease >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self description;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlRepositoryRelease >> projectReleases [ 	
	^ projectReleases ifNil: [ 
		projectReleases := OrderedCollection new ]
]

{ #category : #printing }
GtRlRepositoryRelease >> releaseDetailsDescription [
	^ String streamContents: [ :stream |
		stream 
			nextPutAll: self version description;
			nextPutAll: ', ';
			nextPutAll: self releaseStrategy description ]
]

{ #category : #accessing }
GtRlRepositoryRelease >> releaseStrategy [
	^ releaseStrategy
]

{ #category : #accessing }
GtRlRepositoryRelease >> releaseStrategy: aReleaseStrategy [
	releaseStrategy := aReleaseStrategy
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> remoteOrigin [
	^ self icebergRepository remotes 
		detect: [ :iceRemote | iceRemote name = #origin ]
		
]

{ #category : #accessing }
GtRlRepositoryRelease >> repository [
	^ repository 
]

{ #category : #accessing }
GtRlRepositoryRelease >> repository: aRepository [
	repository := aRepository
]

{ #category : #actions }
GtRlRepositoryRelease >> resetReleaseActions [
	super resetReleaseActions.
	self projectReleases do: #resetReleaseActions
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> semanticVersionTags [
	^ self icebergRepository gtSemanticVersionsTags
]

{ #category : #accessing }
GtRlRepositoryRelease >> setRootRepositoryRelease: aBoolean [
	isRoot := aBoolean 
	
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> urlWithReleaseVersion [
	^ self repository urlWithVersion: self version versionString
]

{ #category : #accessing }
GtRlRepositoryRelease >> version [
	^ version
]

{ #category : #accessing }
GtRlRepositoryRelease >> version: aVersion [
	version := aVersion
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> versionString [
	^ self version versionString
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> versionsMetadata [
	| repositoriesByVersion |
	repositoriesByVersion := (self childRepositoryReleases collect: [ :aRepositoryRelease |
		aRepositoryRelease repository id -> aRepositoryRelease versionString ]) asDictionary.
	^ {'repositories' -> repositoriesByVersion } asDictionary
]

{ #category : #traversing }
GtRlRepositoryRelease >> withAllChildRepositoryReleases [
	^ self withDeepCollect: #childRepositoryReleases
]
