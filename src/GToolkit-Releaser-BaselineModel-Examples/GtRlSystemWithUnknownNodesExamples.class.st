"
I tets a baseline with unknow nodes. Currently release does not have dedicated support for this, so I just catch the corresponsing Metacello error.
"
Class {
	#name : #GtRlSystemWithUnknownNodesExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #'examples - nodes' }
GtRlSystemWithUnknownNodesExamples >> systemProject [
	<gtExample>
	| projectBuilder repositoryName |
	
	repositoryName := 'github://example/SystemWithUnknownNodes/src'.
	projectBuilder := GtRlDependenciesModelBuilder new.
	
	self 
		should: [  
			projectBuilder 
				buildProjectFromBaselineClass: BaselineOfGtRlBaselineExampleWithUnknownNodes
				withRepositoryDescription: repositoryName ]
		raise: MetacelloNameNotDefinedError.
]
