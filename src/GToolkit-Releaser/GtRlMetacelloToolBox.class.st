Class {
	#name : #GtRlMetacelloToolBox,
	#superclass : #MetacelloToolBox,
	#category : #'GToolkit-Releaser'
}

{ #category : #'spec creation' }
GtRlMetacelloToolBox >> createProjectReferenceSpec: projectBaseName [
  | projectSpec |
  projectSpec := (Metacello image
    project: projectBaseName;
    list)
    detect: [ :each | true ]
    ifNone: [ ^ self classicCreateProjectReferenceSpec: projectBaseName ].

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
