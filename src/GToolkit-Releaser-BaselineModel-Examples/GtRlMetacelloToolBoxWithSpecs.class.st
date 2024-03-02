"
I am a toolbox used for testing purposes for handling baselines that are not loaded into the image. 

I make it possible to generate the code of baselines that depend on baselines not loaded into the image. For that I register a list of baselines. When a baseline is not found using `Metacello image` I search for it in the list of registered baselines.


"
Class {
	#name : #GtRlMetacelloToolBoxWithSpecs,
	#superclass : #GtRlMetacelloToolBox,
	#instVars : [
		'specs'
	],
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #accessing }
GtRlMetacelloToolBoxWithSpecs >> addSpecForBaselineClass: aBaselineClass [
	| spec |
	"spec := (aBaselineClass project projectSpec
   		name: (MetacelloScriptEngine baseNameOf: aBaselineClass name asString);
    	repositories: aBaselineClass project projectPackage repositories copy;
    	yourself) asBaselineProjectSpec."
	spec := aBaselineClass project baselineOfProjectSpec
		name: (MetacelloScriptEngine baseNameOf: aBaselineClass name asString);
   		className: aBaselineClass name.
	
	self specs 
		at: (MetacelloScriptEngine baseNameOf: aBaselineClass name asString)
		put: spec
]

{ #category : #'spec creation' }
GtRlMetacelloToolBoxWithSpecs >> createProjectReferenceSpec: projectBaseName [
  | projectSpec |
  projectSpec := (Metacello image
    project: projectBaseName;
    list)
    detect: [ :each | true ]
    ifNone: [ 
		specs 
			at: projectBaseName 
			ifAbsent: [ ^ self classicCreateProjectReferenceSpec: projectBaseName  ] ].

	"Clear the list of repositories from the project spec.
	This avoids having also the default repository together with the new one.
	Did not find an easier way to do this."
	projectSpec repositories: projectSpec repositories copy.
	projectSpec repositories map removeAll.
	projectSpec repositories list removeAll.

  ^ project projectReferenceSpec
    	name: projectBaseName;
    	projectReference: projectSpec;
    	yourself
]

{ #category : #accessing }
GtRlMetacelloToolBoxWithSpecs >> specs [
	^ specs ifNil: [ specs := Dictionary new ]
]
