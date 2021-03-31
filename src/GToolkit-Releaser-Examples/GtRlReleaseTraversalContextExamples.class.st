Class {
	#name : #GtRlReleaseTraversalContextExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'GToolkit-Releaser-Examples'
}

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> emptyTraversalContext [
	<gtExample>
	| traversalContext |
	traversalContext := GtRlReleaseTraversalContext new.
	self assert: traversalContext repositoriesChain isEmpty.
	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> noRecursionErrorIsTriggerInSecondStep [
	<gtExample>
	| traversalContext objectOne objectTwo |
	traversalContext := self emptyTraversalContext.
	objectOne := Object new.
	objectTwo := Object new.
	
	
	traversalContext 
		withRecursionDetectionFor: objectOne 
		during: [ traversalContext withRecursionDetectionFor: objectTwo during: [  ] ].
	self assert: traversalContext repositoriesChain isEmpty.
	
	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> recursionErrorIsTriggerInSecondStep [
	<gtExample>
	| traversalContext objectOne objectTwo |
	traversalContext := self emptyTraversalContext.
	objectOne := Object new.
	objectTwo := objectOne.
	
	self 
		should: [
			traversalContext 
				withRecursionDetectionFor: objectOne 
				during: [ traversalContext withRecursionDetectionFor: objectTwo during: [  ] ] ]
		raise: Error.
	self assert: traversalContext repositoriesChain size equals: 1.
	
	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> recursionErrorIsTriggerInThirdStep [
	<gtExample>
	| traversalContext objectOne objectTwo objectThree |
	traversalContext := self emptyTraversalContext.
	objectOne := Object new.
	objectTwo := Object new.
	objectThree := objectOne.
	
	self 
		should: [
			traversalContext 
				withRecursionDetectionFor: objectOne 
				during: [ traversalContext 
						withRecursionDetectionFor: objectTwo 
						during: [ traversalContext 
							withRecursionDetectionFor: objectThree 
							during: [  ] ] ] ]
		raise: Error.
	self assert: traversalContext repositoriesChain size equals: 2.
	
	^ traversalContext
]
