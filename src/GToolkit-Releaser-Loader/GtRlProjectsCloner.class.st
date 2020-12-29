Class {
	#name : #GtRlProjectsCloner,
	#superclass : #Object,
	#instVars : [
		'loadedBaselines'
	],
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #'as yet unclassified' }
GtRlProjectsCloner >> ensureRepositoryCloneFor: aRepositoryLocationString [
	| mcRepositorySpec mcRepository |
	mcRepositorySpec := MetacelloRepositorySpec new 
		description: aRepositoryLocationString.
	
	(MetacelloPlatform current canHandleType: mcRepositorySpec type)
		ifFalse: [ ^ Error signal: 'Cannot load' ].
	
	mcRepository := Iceberg mcRepositoryFor: mcRepositorySpec description.
	^ mcRepository repository
]

{ #category : #initialization }
GtRlProjectsCloner >> initialize [
	super initialize.
	loadedBaselines := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
GtRlProjectsCloner >> loadBaseline: aBaselineName fromRepository: aRepositoryLocationString [
	| package baselineClassName baselineClass project |
	
	NonInteractiveTranscript stdout
		cr;
		show: 'Process ', aBaselineName.
	(loadedBaselines includes: aBaselineName)
		ifTrue: [ 
			NonInteractiveTranscript stdout
				cr;
				show: 'Already processed ';
				cr.
			^ self ].
	
	NonInteractiveTranscript stdout
		cr;
		show: 'Load baseline';
		cr.
	package := self 
		loadBaselinePackageFor: aBaselineName 
		fromRepository: aRepositoryLocationString.
	
	baselineClassName := MetacelloScriptEngine baselineNameFrom: aBaselineName.
	baselineClass := package classes
		detect: [ :each | each name = baselineClassName ].
	
	project := GtRlLocalDependenciesModelBuilder new
		buildProjectFromBaselineClass: baselineClass
		withRepositoryDescription: aRepositoryLocationString.
	loadedBaselines add: aBaselineName.
	
	project childProjects do: [ :aProject |
		self 
			loadBaseline: aProject name 
			fromRepository: aProject repository urlString ].
	
	^ project
]

{ #category : #accessing }
GtRlProjectsCloner >> loadBaselinePackageFor: aBaselineName fromRepository: aRepositoryLocationString [
	| icebergRepository icebergPackage baselineClassName |
	baselineClassName := MetacelloScriptEngine baselineNameFrom: aBaselineName.
	"(RPackage organizer includesPackageNamed: baselineClassName)
		ifTrue: [ ^ RPackage organizer packageNamed: baselineClassName ]."
	
	icebergRepository := self ensureRepositoryCloneFor: aRepositoryLocationString.
	(icebergRepository workingCopy packageNames 
		includes: baselineClassName)
			ifFalse: [ Error signal: 'Cannot find baseline package' ].
	
	icebergPackage := icebergRepository workingCopy packageNamed: baselineClassName.
	icebergPackage load.
	
	^ RPackage organizer 
		packageNamed: icebergPackage name
]
