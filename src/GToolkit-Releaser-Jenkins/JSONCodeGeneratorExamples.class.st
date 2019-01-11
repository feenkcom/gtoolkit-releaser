Class {
	#name : #JSONCodeGeneratorExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Jenkins-Examples'
}

{ #category : #examples }
JSONCodeGeneratorExamples >> hudsonClass [
	<gtExample>
	| theClass |
	theClass := (JSONCodeGenerator new modelFrom: self hudsonExampleAsDictionary) class.
	self assert: theClass name equals: #Hudson.
	self assert: theClass package name equals: 'GToolkit-Releaser-Jenkins'.
	^ theClass
]

{ #category : #examples }
JSONCodeGeneratorExamples >> hudsonExampleAsDictionary [
	<gtExample>
	|dictionary|
	dictionary := NeoJSONReader fromString: (self hudsonPrettyStringExample).
	self assert: dictionary keys size equals: 2.
	^ dictionary 
	
]

{ #category : #examples }
JSONCodeGeneratorExamples >> hudsonObject [
	<gtExample>
	| theObject |
	theObject := (JSONCodeGenerator new modelFrom: self hudsonExampleAsDictionary).
	^ theObject
]

{ #category : #examples }
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
