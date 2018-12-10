Class {
	#name : #GtRlRepositoryRelease,
	#superclass : #GtRlRelease,
	#instVars : [
		'version',
		'releaseStrategy',
		'repository',
		'projectReleases'
	],
	#category : #'GToolkit-Releaser'
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

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> allChildRepositoryReleases [
	^ self withDeepCollect: #childRepositoryReleases
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
		withMessage: 'Release version ', self versionString 
		force: true.
	iceRepository branch commit ensureCreateTag: self versionString.
		
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
		itemFormat: [ :anIceTag |
			anIceTag name, ' [', (anIceTag commit id first: 7), ']' ]
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
						addChild: children. ];
				with: repos;
				forEach: [ :aRepositoryRelease | 
					mondrian nodes
						shape: [ :aProjectRelease ||textColor text|
							textColor := (aProjectRelease isPassiveRelease or: [ aProjectRelease isLeaf ])
								ifTrue: [ Color gray ] ifFalse: [ Color black ].
							text := aProjectRelease project name asRopedText foreground: textColor.
							(BlTextElement text: text)
								constraintsDo: [ :c | 
									c padding: (BlInsets all: 2).
									c linear horizontal alignCenter ] ];
						with: aRepositoryRelease projectReleases.
					mondrian layout vertical ].
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
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #accessing }
GtRlRepositoryRelease >> icebergRepository [
	^ self repository icebergRepository
]

{ #category : #testing }
GtRlRepositoryRelease >> isPassiveRelease [
	^ self releaseStrategy allowsReleaseGeneration not
]

{ #category : #actions }
GtRlRepositoryRelease >> mergeToBranch: aBranchName [
	| initialBranchName icebergRepository |
	icebergRepository := self icebergRepository.
	initialBranchName := icebergRepository branchName.
	
	icebergRepository checkoutBranch: aBranchName.
	"[icebergRepository switchToBranchNamed: aBranchName] 
		on: Warning do: [ :ex | ex resume ]."
	
	"Do the merge from the current branch"
	IceMerge new 
		repository: icebergRepository; 
		mergeCommit: (icebergRepository branchNamed: initialBranchName) commit; 
		executeWithAcceptingLeftOnConflict.
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> parentRepositoryReleases [
	^ (self projectReleases flatCollect: [ :aProjectRelease | 
		aProjectRelease parentReleases collect: #repositoryRelease ]) removeDuplicates 
			remove: self ifAbsent: [ ];
			yourself
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
			nextPutAll: self releaseStrategy releaseTarget ]
]

{ #category : #accessing }
GtRlRepositoryRelease >> releaseStrategy [
	^ releaseStrategy
]

{ #category : #accessing }
GtRlRepositoryRelease >> releaseStrategy: aReleaseStrategy [
	self 
		assert: [ aReleaseStrategy repositoryRelease isNil ] 
		description: 'The release strategy should not be attached at this point to any repository'.
	releaseStrategy := aReleaseStrategy.
	aReleaseStrategy repositoryRelease: self.
]

{ #category : #accessing }
GtRlRepositoryRelease >> repository [
	^ repository 
]

{ #category : #accessing }
GtRlRepositoryRelease >> repository: aRepository [
	repository := aRepository
]

{ #category : #'accessing - dynamic' }
GtRlRepositoryRelease >> semanticVersionTags [
	^ self icebergRepository tags select: #gtIsSemanticVersion
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
