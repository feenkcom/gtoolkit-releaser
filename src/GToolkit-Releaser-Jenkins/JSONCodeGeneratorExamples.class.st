Class {
	#name : #JSONCodeGeneratorExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Jenkins-Examples'
}

{ #category : #'as yet unclassified' }
JSONCodeGeneratorExamples >> hudsonClass [
	<gtExample>
	| theClass |
	theClass := JSONCodeGenerator new modelFrom: self hudsonExampleAsDictionary.
	self assert: theClass name equals: #Hudson.
	self assert: theClass package name equals: 'HudsonModel'.
	^ theClass
]

{ #category : #'as yet unclassified' }
JSONCodeGeneratorExamples >> hudsonExampleAsDictionary [
	<gtExample>
	|dictionary|
	dictionary := NeoJSONReader fromString: (self hudsonPrettyStringExample).
	self assert: dictionary keys size equals: 2.
	^ dictionary 
	
]

{ #category : #'as yet unclassified' }
JSONCodeGeneratorExamples >> hudsonPrettyStringExample [
	^ '{
  "_class" : "hudson.model.Hudson",
  "jobs" : [
    {
      "_class" : "jenkins.branch.OrganizationFolder",
      "name" : "feenkcom"
    },
    {
      "_class" : "hudson.model.FreeStyleProject",
      "name" : "gtoolkit"
    },
    {
      "_class" : "hudson.model.FreeStyleProject",
      "name" : "Synch Bloc"
    },
    {
      "_class" : "jenkins.branch.OrganizationFolder",
      "name" : "syrel"
    },
    {
      "_class" : "hudson.model.FreeStyleProject",
      "name" : "vm-maker"
    }
  ]
}'
]
