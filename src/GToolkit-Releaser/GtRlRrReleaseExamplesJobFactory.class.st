Class {
	#name : #GtRlRrReleaseExamplesJobFactory,
	#superclass : #Object,
	#instVars : [
		'packageNamesToSkip'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> allPackageNames [
	| baselineProject packages packageNames |
	
	baselineProject := BaselineOfGToolkit fullBaselineProject.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage |
		aPackage gtExamplesAllContained isNotEmpty ].
	
	packageNames := packages collect: [ :aPackage | aPackage name ].
	
	^ packageNames
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> defaultSkippedPackageNames [

	^ #(
		'GToolkit-Boxer' 
		'Sparta-Cairo' 
		'Sparta-Skia' 
		'GToolkit-RemoteExamples-GemStone' 
		'PythonBridge-Pharo' )
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> job [
	| factory |

	factory := GtRrChecksFactory new.
	self packageNames do: [ :name |
		factory addExampleClasses: name asPackage classes ].
	factory groupTasksByAverageTime.
	^ factory job
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> packageNames [

	^ self allPackageNames difference: self packageNamesToSkip
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> packageNamesToSkip [
	^ packageNamesToSkip ifNil: [ #() ]
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> packageNamesToSkip: anObject [
	packageNamesToSkip := anObject
]

{ #category : #configuration }
GtRlRrReleaseExamplesJobFactory >> skipDefaultPackages [

	self packageNamesToSkip: (self packageNamesToSkip asSet addAll: self defaultSkippedPackageNames)
]
