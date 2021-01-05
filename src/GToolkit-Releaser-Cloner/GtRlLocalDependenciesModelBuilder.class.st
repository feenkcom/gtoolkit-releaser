Class {
	#name : #GtRlLocalDependenciesModelBuilder,
	#superclass : #GtRlDependenciesModelBuilder,
	#category : #'GToolkit-Releaser-Cloner-Core'
}

{ #category : #building }
GtRlLocalDependenciesModelBuilder >> buildProjectFromMetacelloSpec: aMetacelloProjectSpec [
	| newProject |
	self assert: [ aMetacelloProjectSpec project versions size = 1 ].
	self assert: [ aMetacelloProjectSpec repositorySpecs size = 1 ].
	self assert: [ aMetacelloProjectSpec className notNil ].

	"If the project was already created return the existing project.
	This does not initialize any dependencies as it assumes they are already initialized."
	(self projectsByBaselineClass includesKey: aMetacelloProjectSpec className)
		ifTrue: [ ^ self projectsByBaselineClass at: aMetacelloProjectSpec className ]
	
	"If this is the first time the project is encountered, create it and initalize its dependencies".
	newProject := self instantiateProjectFromMetacelloSpec: aMetacelloProjectSpec.
	
	"Only add the project to the "
	self projectsByBaselineClass at: aMetacelloProjectSpec projectClass put: newProject.
	
	^ newProject
]

{ #category : #'private - building' }
GtRlLocalDependenciesModelBuilder >> instantiateProjectFromMetacelloSpec: aBaselineProjectSpec [
	| repositoriesSpec |
	repositoriesSpec := aBaselineProjectSpec repositories.
	self assert: [ repositoriesSpec map size = 1 ].
	^ GtRlUnresolvedProject new 
		name: (MetacelloScriptEngine baseNameOf: aBaselineProjectSpec className);
		linkWithRepository: (self ensureRepositoriesFor: repositoriesSpec map values first description) 
]

{ #category : #dependencies }
GtRlLocalDependenciesModelBuilder >> updateProjectDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| projectReferences |
	projectReferences := (aMetacelloVersion projects 
		"select: [ :aMetacelloProjectSpec || shouldKeep |
			shouldKeep := aMetacelloProjectSpec version notNil and: [ 
				aMetacelloProjectSpec version name = 'baseline' ].
			shouldKeep ifFalse: [ 
				StringSignal emit: ('Ignoring dependency ', aMetacelloProjectSpec className, ' of ', currentProject name) ].
			shouldKeep ]")
		collect: [ :aMCProjectSpec | 
			| referencedProject |
			referencedProject := self buildProjectFromMetacelloSpec: aMCProjectSpec.
			GtRlProjectReference new 
				referencedProject: referencedProject ].
	currentProject addProjectReferences: projectReferences.
]
