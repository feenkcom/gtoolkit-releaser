Class {
	#name : #GtRlUnknownNodeExamples,
	#superclass : #Object,
	#category : 'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlUnknownNodeExamples >> unknowNode [
	<gtExample>
	| node |
	
	node := GtRlUnknownNode new
		name: 'Unknown'.
	
	self assert: node isProjectReference not.
	self assert: node isPackageNode not.
	self assert: node isUnknownNode.
	
	^ node
]

{ #category : #examples }
GtRlUnknownNodeExamples >> unknowNodeWithIncommingDependency [
	<gtExample>
	| unknownNode package |
	
	unknownNode := self unknowNode.
	
	package := GtRlPackage new
		name: 'Package'.
	unknownNode addIncomingDependency: (GtRlPackageDependency new 
		sourceNode: package;
		targetNode: unknownNode). 
		
	self assert: unknownNode incomingDependencies size equals: 1.
	
	^ unknownNode
]
