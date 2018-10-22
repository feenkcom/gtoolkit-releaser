Class {
	#name : #FkRlProject,
	#superclass : #Object,
	#instVars : [
		'baselineVersion',
		'baselineClass',
		'repositorySpec',
		'projectDependencies'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #examples }
FkRlProject class >> codeGeneration [
	| project |
	project := FkRlProject 
		fromBaselineClass: BaselineOfGToolkit
		fromRepositoryDescription: 'github://feenkcom/gtoolkit-debugger/src'.
	project updateDependencies.
	project generateSource.
]

{ #category : #'instance creation' }
FkRlProject class >> fromBaselineClass: aBaselineClass fromRepositoryDescription: aRepositoryUrl [
	self assert: [ aBaselineClass project versions size = 1 ].
	^ self new 
		repositorySpec: (MetacelloRepositoriesSpec new
			add: (MetacelloRepositorySpec new 
				description: aRepositoryUrl;
				yourself);
			yourself);
		baselineVersion: aBaselineClass project versions first;
		baselineClass: aBaselineClass.
]

{ #category : #'instance creation' }
FkRlProject class >> fromProjectSpec: aBaselineProjectSpec [
	self assert: [ aBaselineProjectSpec project versions size = 1 ].
	self assert: [ aBaselineProjectSpec repositorySpecs size = 1 ].
	^ self new 
		repositorySpec: aBaselineProjectSpec version spec repositories;
		baselineVersion: aBaselineProjectSpec version;
		baselineClass: aBaselineProjectSpec projectClass.
]

{ #category : #accessing }
FkRlProject >> baselineClass [
	^ baselineClass
]

{ #category : #accessing }
FkRlProject >> baselineClass: aBaselineClass [
	baselineClass := aBaselineClass
]

{ #category : #'accessing - dynamic' }
FkRlProject >> baselineProject [ 
	^ self baselineVersion project
]

{ #category : #accessing }
FkRlProject >> baselineVersion [
	^ baselineVersion
]

{ #category : #accessing }
FkRlProject >> baselineVersion: aMetacelloVersion [
	self assert: [ aMetacelloVersion name = 'baseline' ].
	self assert: [ aMetacelloVersion versionNumber versionString = 'baseline' ].
	baselineVersion := aMetacelloVersion
]

{ #category : #actions }
FkRlProject >> generateSource [
	| toolbox |
  (toolbox := FkRlMetacelloToolBox baselineNamed: 'BaselineOfGToolkit')
    createBaselineOfMethod: 'baseline:' inCategory: 'baseline';
    addBaselineOfSection: #'common'
      requiredProjects: self subprojectsNames
      packages: #()
      repositories: self subprojectsWithNewRepositories
      dependencies: #()
      groups: #()
      versionSpecsDo: [ :versionSpec | ].
  ^ toolbox methodSpec methodSource
]

{ #category : #printing }
FkRlProject >> gtDisplayOn: stream [
	stream 
		nextPutAll: self baselineVersion printString
]

{ #category : #ui }
FkRlProject >> gtProjectMapFor: aView [
	<gtView>
	^ self baselineVersion ifNotNil: [ :aBaselineVersion |
		aBaselineVersion gtProjectMapFor: aView ]
]

{ #category : #initialization }
FkRlProject >> initialize [ 
	super initialize.
	projectDependencies := OrderedCollection new.
]

{ #category : #accessing }
FkRlProject >> projectDependencies [
	^ projectDependencies
]

{ #category : #accessing }
FkRlProject >> repositorySpec [
	^ repositorySpec
]

{ #category : #accessing }
FkRlProject >> repositorySpec: aRepositorySpec [
	repositorySpec := aRepositorySpec 
]

{ #category : #'accessing - dynamic' }
FkRlProject >> subprojectsNames [
	^ self projectDependencies collect: [ :each | 
		MetacelloScriptEngine baseNameOf: each  baselineClass name ]
]

{ #category : #'accessing - dynamic' }
FkRlProject >> subprojectsWithNewRepositories [
	^ self projectDependencies collect: [ :each |
		| simpleName currentUrl |
		simpleName := MetacelloScriptEngine baseNameOf: each baselineClass name.
		currentUrl := ZnUrl fromString: each repositorySpec list first name.
		currentUrl segments at: 1 put: (currentUrl segments at: 1), ':v1.1.1'. 
		simpleName -> {currentUrl printString} ]
]

{ #category : #actions }
FkRlProject >> updateDependencies [
	| newProjects |
	newProjects := self baselineVersion projects collect: [ :aMetacelloProjectSpec |
		self class fromProjectSpec: aMetacelloProjectSpec ].
	"newProjects do: #updateDependencies."
	self projectDependencies addAll: newProjects
	
]
