Class {
	#name : #FkRlRepositoryRelease,
	#superclass : #FkRlRelease,
	#instVars : [
		'branchName',
		'version',
		'repository',
		'projectReleases'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #accessing }
FkRlRepositoryRelease >> addProjectRelease: aProjectRelease [
	aProjectRelease repositoryRelease: self.
	^ self projectReleases add: aProjectRelease
]

{ #category : #accessing }
FkRlRepositoryRelease >> branchName [
	^ branchName
]

{ #category : #accessing }
FkRlRepositoryRelease >> branchName: aBranchName [
	branchName := aBranchName
]

{ #category : #'accessing - dynamic' }
FkRlRepositoryRelease >> childReleases [
	^ (self projectReleases flatCollect: [ :aProjectRelease | 
		aProjectRelease childReleases collect: #repositoryRelease ]) asSet
			remove: self ifAbsent: [ ];
			yourself
]

{ #category : #printing }
FkRlRepositoryRelease >> description [
	^ String streamContents: [ :stream |
		stream nextPutAll: self repository id.
		stream nextPutAll: ', ', self version versionString.
		stream nextPutAll: ' (#', self branchName, ')' ]
]

{ #category : #ui }
FkRlRepositoryRelease >> gtProjectsFor: aView [
	<gtView>
	^ aView list 
		title: 'Project releases' translated;
		items: [ self projectReleases ]
]

{ #category : #ui }
FkRlRepositoryRelease >> gtRepoMapFor: aView [
	<gtView> 
	^ aView mondrian 
	  title: 'Release Map' translated;
	  priority: 10; 
	  painting: [ :mondrian | 
			| repos |
			repos := (self withDeepCollect: #childReleases) asSet.
			mondrian nodes 
				umlClassShapeWithName: [ :aRepositoryRelease | aRepositoryRelease description ];
				with: repos;
				forEach: [ :aRepositoryRelease | 
					mondrian nodes
						shape: [ :aProjectRelease |
							(BlTextElement text: aProjectRelease project name asRopedText)
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
					dependedRepos := each childReleases.
					repos select: [ :project | dependedRepos anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
]

{ #category : #printing }
FkRlRepositoryRelease >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self repository urlString;
		nextPutAll: ', ';
		nextPutAll: self version versionString;
		nextPutAll: ')'
]

{ #category : #accessing }
FkRlRepositoryRelease >> projectReleases [ 	
	^ projectReleases ifNil: [ 
		projectReleases := OrderedCollection new ]
]

{ #category : #accessing }
FkRlRepositoryRelease >> repository [
	^ repository 
]

{ #category : #accessing }
FkRlRepositoryRelease >> repository: aRepository [
	repository := aRepository
]

{ #category : #accessing }
FkRlRepositoryRelease >> version [
	^ version
]

{ #category : #accessing }
FkRlRepositoryRelease >> version: aVersion [
	version := aVersion
]
