Class {
	#name : #GtRlRrReleaseExamplesJobFactory,
	#superclass : #Object,
	#instVars : [
		'packageNamesToSkip',
		'packageNames'
	],
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> allPackageNames [
	| baselineProject packages allPackageNames |
	
	baselineProject := BaselineOfGToolkit fullBaselineProject.
	packages := baselineProject withAllContainedRPackagesSelect: [ :aPackage |
		aPackage gtExamplesAllContained isNotEmpty ].
	
	allPackageNames := packages collect: [ :aPackage | aPackage name ].
	
	^ allPackageNames
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

{ #category : #views }
GtRlRrReleaseExamplesJobFactory >> gtPackageNamesFor: aView [
	<gtView>
	packageNames ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'PackageNames';
		items: [ packageNames ];
		column: 'Value' text: [ :each | each gtDisplayString ]
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

{ #category : #configuration }
GtRlRrReleaseExamplesJobFactory >> limit: anInteger [

	packageNames := self packageNames first: anInteger
]

{ #category : #accessing }
GtRlRrReleaseExamplesJobFactory >> packageNames [

	^ packageNames ifNil:
		[ packageNames := self allPackageNames difference: self packageNamesToSkip ]
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

{ #category : #configuration }
GtRlRrReleaseExamplesJobFactory >> sortPackageNames [

	packageNames := self packageNames sorted.
]
