"
I am a {{gtClass:MetacelloToolBox}} that only uses the given repository for a baseline, instead of using all repositories that Metacello knows about a baseline in the current image. If all repositories are used then all repositories will be in the generated code of a baseline, instead of only the repositories contained by the model of a loading configuration.


"
Class {
	#name : #GtRlMetacelloToolBox,
	#superclass : #MetacelloToolBox,
	#category : #'GToolkit-Releaser-BaselineModel-Model'
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
