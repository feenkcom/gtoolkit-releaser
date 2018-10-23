Class {
	#name : #FkRlModelBuilder,
	#superclass : #Object,
	#instVars : [
		'projectsByBaselineClass',
		'projectsChain'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #visiting }
FkRlModelBuilder >> buildProjectFromBaselineClass: aBaselineClass withRepositoryDescription: aRepositoryUrl [
	| newProject mcVersion |
	self assert: [ aBaselineClass project versions size = 1 ].
	
	mcVersion := aBaselineClass project versions first.
	newProject := FkRlProject new
		name: (MetacelloScriptEngine baseNameOf: aBaselineClass name); 
		repositorySpec: (self createRepositoriesSpecFor: aRepositoryUrl);
		baselineVersion: mcVersion;
		baselineClass: aBaselineClass.
	
	self updateDependenciesFor: newProject fromMCVersion: mcVersion.
	self projectsByBaselineClass at: aBaselineClass put: newProject.
	
	^ newProject
]

{ #category : #visiting }
FkRlModelBuilder >> buildProjectFromMetacelloSpec: aMCBaselineProjectSpec [
	| newProject |
	self assert: [ aMCBaselineProjectSpec project versions size = 1 ].
	self assert: [ aMCBaselineProjectSpec repositorySpecs size = 1 ].
	
	"If the project was already created return the existing project.
	This does not initialize any dependencies as it assumes they are already initialized."
	(self projectsByBaselineClass includesKey: aMCBaselineProjectSpec projectClass)
		ifTrue: [ ^ self projectsByBaselineClass at: aMCBaselineProjectSpec projectClass ]
	
	"If this is the first time the project is encountered, create it and initalize its dependencies".
	newProject := self instantiateProjectFromMetacelloSpec: aMCBaselineProjectSpec.
	self 
		updateDependenciesFor: newProject 
		fromMCVersion: aMCBaselineProjectSpec version.
	
	"Only add the project to the "
	self projectsByBaselineClass at: aMCBaselineProjectSpec projectClass put: newProject.
	
	^ newProject
]

{ #category : #visiting }
FkRlModelBuilder >> createRepositoriesSpecFor: aRepositoryUrl [
	^ MetacelloRepositoriesSpec new
			add: (MetacelloRepositorySpec new 
				description: aRepositoryUrl;
				yourself);
			yourself
]

{ #category : #initialize }
FkRlModelBuilder >> initialize [ 
	super initialize.
	projectsByBaselineClass := IdentityDictionary new.
	projectsChain := OrderedCollection new.
]

{ #category : #visiting }
FkRlModelBuilder >> instantiateProjectFromMetacelloSpec: aBaselineProjectSpec [
	^ FkRlProject new 
		name: (MetacelloScriptEngine baseNameOf: aBaselineProjectSpec projectClass name);
		repositorySpec: aBaselineProjectSpec version spec repositories;
		baselineVersion: aBaselineProjectSpec version;
		baselineClass: aBaselineProjectSpec projectClass 
]

{ #category : #accessing }
FkRlModelBuilder >> projectsByBaselineClass [
	^ projectsByBaselineClass
]

{ #category : #visiting }
FkRlModelBuilder >> updateDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| childProjects |
	childProjects := (aMetacelloVersion projects 
		select: [ :aMetacelloProjectSpec || shouldReject |
			shouldReject := aMetacelloProjectSpec version notNil and: [ 
				aMetacelloProjectSpec version name = 'baseline' ].
			shouldReject ifFalse: [ 
				('Ignoring dependency ', aMetacelloProjectSpec className, ' of ', currentProject name) logCr ].
			shouldReject ])
		collect: [ :aMCProjectSpec | 
			self buildProjectFromMetacelloSpec: aMCProjectSpec ].
	currentProject addChildProjects: childProjects.
]
