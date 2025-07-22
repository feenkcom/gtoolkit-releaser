"
I model a project that resides within a repository, has dependencies to other projects and loads certain packages from the repository. I correspond to a Monticello baseline.

I have as main attributes: 
	- the name of the project
	- the list of packages loaded by the project 
	- the repositry containing the project 
	- a list of child and parent projects representing my dependencies to other projects


"
Class {
	#name : #GtRlProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'baselineClass',
		'repository',
		'parentProjects',
		'projectReferences',
		'packages',
		'preLoadAction',
		'postLoadAction',
		'properties'
	],
	#category : #'GToolkit-Releaser-BaselineModel-Model'
}

{ #category : #'instance creation' }
GtRlProject class >> withName: projectName [
	^ self new
		name: projectName
]

{ #category : #adding }
GtRlProject >> addPackage: aPackage [
	self assert: [ aPackage notNil ].
	
	aPackage parentProject: self. 
	self packages add: aPackage.
]

{ #category : #adding }
GtRlProject >> addPackages: aCollection [
	aCollection do: [ :aPackage |
		self addPackage: aPackage ]
]

{ #category : #adding }
GtRlProject >> addProjectReference: aProjectReference [
	self assert: [ aProjectReference notNil ].
	self assert: [ aProjectReference referencedProject notNil ].
	
	self projectReferences add: aProjectReference.
	aProjectReference parentProject: self.
	aProjectReference referencedProject basicAddParentProject: self.
]

{ #category : #adding }
GtRlProject >> addProjectReferences: aCollection [
	aCollection do: [ :aProjectReference | 
		self addProjectReference: aProjectReference ]
]

{ #category : #traversing }
GtRlProject >> allPPackages [
	^ self 
		withDeep: #childProjects 
		flatCollect: [ :aProject | 
			aProject packages collect: [ :aRlPackage | aRlPackage asRPackage ] ]
]

{ #category : #traversing }
GtRlProject >> allPackages [
	^ self 
		withDeep: #childProjects 
		flatCollect: [ :aProject | 
			aProject packages ]
]

{ #category : #traversing }
GtRlProject >> allProjectReferences [
	^ self
		withDeep: [ :aProject | aProject childProjects ] 
		flatCollect: [ :aProject | aProject projectReferences ]
]

{ #category : #accessing }
GtRlProject >> baselineClass [
	^ baselineClass
]

{ #category : #accessing }
GtRlProject >> baselineClass: aBaselineClass [
	baselineClass := aBaselineClass
]

{ #category : #baselines }
GtRlProject >> baselineGenerator [
	^ GtRlProjectBaselineGenerator forProject: self
]

{ #category : #'accessing - metacello' }
GtRlProject >> baselineVersion [
	^ self 
		propertyAt: #baselineVersion 
		ifAbsent: [ nil ]
]

{ #category : #'accessing - metacello' }
GtRlProject >> baselineVersion: aMetacelloVersion [
	self assert: [ aMetacelloVersion name = 'baseline' ].
	self assert: [ aMetacelloVersion versionNumber versionString = 'baseline' ].
	
	self 
		propertyAt: #baselineVersion 
		put: aMetacelloVersion.
	
	aMetacelloVersion spec preLoadDoIt ifNotNil: [ :aPreLoadSpec |
		self 
			assert: [ aPreLoadSpec isKindOf: MetacelloValueHolderSpec ] 
			description: 'Only MetacelloValueHolderSpec are supported as pre load actions'.
		self preLoadAction: aPreLoadSpec value ].
	aMetacelloVersion spec postLoadDoIt ifNotNil: [ :aPostLoadSpec |
		self 
			assert: [ aPostLoadSpec isKindOf: MetacelloValueHolderSpec ] 
			description: 'Only MetacelloValueHolderSpec are supported as post load actions'.
		self postLoadAction: aPostLoadSpec value ]
]

{ #category : #private }
GtRlProject >> basicAddParentProject: aParentProject [
	self parentProjects add: aParentProject
]

{ #category : #accessing }
GtRlProject >> childProjects [
	^ self projectReferences collect: [ :aProjectReference |
		aProjectReference referencedProject ]
]

{ #category : #traversing }
GtRlProject >> containedRPackagesDo: aBloc [
	self packages do: [ :aReleaserPackage |
		(self class packageOrganizer
			packageNamed: aReleaserPackage name 
			ifAbsent: [nil]) ifNotNil: [ :aRPackage | 
				aBloc value: aRPackage ] ]
]

{ #category : #ui }
GtRlProject >> gtChildProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Child projects' translated;
		items: [ self childProjects ];
		itemText: #name;
		priority: 46
]

{ #category : #ui }
GtRlProject >> gtMCProjectMapFor: aView [
	<gtView>
	^ self baselineVersion 
		ifNil: [ aView empty ]
		ifNotNil: [ :aBaselineVersion |
			(aBaselineVersion gtProjectMapFor: aView)
				title: 'MC map' translated;
				priority: 70 ]
]

{ #category : #ui }
GtRlProject >> gtParentProjectsFor: aView [
	<gtView>
	^ aView list
		title: 'Parent projects' translated;
		items: [ self parentProjects ];
		itemText: #name;
		priority: 45
]

{ #category : #ui }
GtRlProject >> gtProjectMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Project map' translated;
		priority: 1;
		painting: [ :mondrian |
			mondrian nodes 
				shape: [ :aProject |
					BrLabel new text: aProject name; aptitude: BrGlamorousLabelAptitude ];
				with: self withAllChildProjects.
			mondrian edges
				shape: [ 
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.5); width: 2; build)) ];
				fromRightCenter;
				toLeftCenter;
				connectToAll: #childProjects.
			mondrian layout custom: (GtGradWestHierarchicalLayout new) ]
]

{ #category : #ui }
GtRlProject >> gtProjectReferencesFor: aView [
	<gtView>
	^ aView list
		title: 'Project references' translated;
		items: [ self projectReferences ];
		itemText: [ :aProjectReference |
			aProjectReference referencedProject name ];
		priority: 55
]

{ #category : #ui }
GtRlProject >> gtRepoMapFor: aView [
	<gtView> 
	^ self repository 
		ifNil: [ aView empty ]
		ifNotNil:  [ :aRepository | 
			(aRepository gtRepoMapFor: aView)
				priority: 60 ]
]

{ #category : #ui }
GtRlProject >> gtSourceFor: aView [
	<gtView> 
	self baselineVersion ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Source' translated;
		styler: (BrRBTextStyler new
			isForWorkspace: true);
		text: [ String streamContents: [ :s | 
			self baselineVersion spec configMethodOn: s] ];
		priority: 55
]

{ #category : #ui }
GtRlProject >> gtViewRepositoriesListFor: aView [
	<gtView>
	^ aView list
		title: 'Packages' translated;
		items: [ self packages ];
		itemText: #name;
		priority: 60
]

{ #category : #testing }
GtRlProject >> hasPostLoadActionSpecified [
	^ self postLoadAction notNil
]

{ #category : #testing }
GtRlProject >> hasPreLoadActionSpecified [
	^ self preLoadAction notNil
]

{ #category : #initialization }
GtRlProject >> initialize [ 
	super initialize.
	packages := OrderedCollection new.
	parentProjects := OrderedCollection new.
	projectReferences := OrderedCollection new.
]

{ #category : #testing }
GtRlProject >> isLeaf [
	^ self childProjects isEmpty
]

{ #category : #actions }
GtRlProject >> linkWithRepository: aRepository [
	self repository: aRepository.
	(GtRlProjectLinkWithRepositorySignal project: self repository: aRepository) emit.
	aRepository addProject: self
]

{ #category : #'accessing - metacello' }
GtRlProject >> metacelloToolbox [
	^ self 
		propertyAt: #metacelloToolbox 
		ifAbsent: [ GtRlMetacelloToolBox new ]
]

{ #category : #'accessing - metacello' }
GtRlProject >> metacelloToolbox: aMetacelloToolbox [
	"This only exists to make tests work without loading the baseline for tests packages."
	self 
		propertyAt: #metacelloToolbox 
		put: aMetacelloToolbox
]

{ #category : #accessing }
GtRlProject >> name [ 	
	^ name
]

{ #category : #accessing }
GtRlProject >> name: aString [
	name := aString
]

{ #category : #accessing }
GtRlProject >> packages [
	^ packages
]

{ #category : #accessing }
GtRlProject >> parentProjects [
	^ parentProjects
]

{ #category : #accessing }
GtRlProject >> postLoadAction [
	"Return the action for executing after the project was loaded.
	${example:GtRlProjectExamples>>#projectWithPostLoadAction}$
	"
	^ postLoadAction
]

{ #category : #accessing }
GtRlProject >> postLoadAction: aSymbol [
	"Set a selector existing in the baseline class that will be executed after the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPostLoadAction}$"
	postLoadAction := aSymbol
]

{ #category : #accessing }
GtRlProject >> preLoadAction [
	"Return the action for executing before the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPreLoadAction}$"
	^ preLoadAction
]

{ #category : #accessing }
GtRlProject >> preLoadAction: aSymbol [
	"Set a selector existing in the baseline class that will be executed after the project is loaded.
	${example:GtRlProjectExamples>>#projectWithPreLoadAction}$"
	preLoadAction := aSymbol
]

{ #category : #printing }
GtRlProject >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : #accessing }
GtRlProject >> projectReferences [
	^ projectReferences
]

{ #category : #'accessing - properties' }
GtRlProject >> properties [
	^ properties ifNil: [ 
		properties := Dictionary new ]
]

{ #category : #'accessing - properties' }
GtRlProject >> propertyAt: aKey [
	"Answer the property value associated with aKey."
	
	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ].
]

{ #category : #'accessing - properties' }
GtRlProject >> propertyAt: propertyName ifAbsent: aBlock [
	^ self properties
		at: propertyName
		ifAbsent: aBlock
]

{ #category : #'accessing - properties' }
GtRlProject >> propertyAt: propertyName put: propValue [
	^ self properties
		at: propertyName
		ifAbsentPut: propValue
]

{ #category : #accessing }
GtRlProject >> repository [
	^ repository
]

{ #category : #accessing }
GtRlProject >> repository: aRepository [
	repository := aRepository 
]

{ #category : #'accessing - dynamic' }
GtRlProject >> rootPackages [
	"Return the list of packages on which other packages do not depend upon."
	^ self packages select: [ :aPackage |
		aPackage dependentPackages isEmpty ].
]

{ #category : #traversing }
GtRlProject >> withAllChildProjects [
	^ self withDeepCollect: #childProjects
]

{ #category : #traversing }
GtRlProject >> withAllChildProjectsCollect: aBlock [
	^ self withDeep: #childProjects collect: aBlock
]

{ #category : #traversing }
GtRlProject >> withAllChildProjectsDo: aBlock [
	^ self withDeep: #childProjects do: aBlock
]

{ #category : #traversing }
GtRlProject >> withAllContainedRPackagesSelect: aBloc [
	| result |
	result := OrderedCollection new.
	self withAllChildProjectsDo: [ :aProject |
		aProject containedRPackagesDo:  [ :aRPackage | 
			(aBloc value: aRPackage) ifTrue: [ result add: aRPackage ] ] ]. 
	^ result
]

{ #category : #'accessing - dynamic' }
GtRlProject >> withAllRepositories [
	"Return all repositores that can be reached from the this project, 
	including the repository holding this project."
	^ (self withDeep: #childProjects collect: #repository) removeDuplicates
]
