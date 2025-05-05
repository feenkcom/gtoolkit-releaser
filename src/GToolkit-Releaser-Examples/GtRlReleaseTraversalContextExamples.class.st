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
	<return: #GtRlReleaseTraversalContext>
	| traversalContext |
	traversalContext := GtRlReleaseTraversalContext new.
	self assert: traversalContext repositoriesChain isEmpty.
	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> noRecursionErrorIsTriggerInSecondStep [
	<gtExample>
	<return: #GtRlReleaseTraversalContext>
	| traversalContext objectOne objectTwo |
	traversalContext := self emptyTraversalContext.
	objectOne := GtRlRepositoryRelease new.
	objectOne
		repository: (GtRlRepository new
				loadSpecification: (GtRlRepositoryLoadSpecification fromUrlString: 'some://nice/url1/src')).
	objectTwo := GtRlRepositoryRelease new.
	objectTwo
		repository: (GtRlRepository new
				loadSpecification: (GtRlRepositoryLoadSpecification fromUrlString: 'some://nice/url2/src')).


	traversalContext
		withRecursionDetectionFor: objectOne
		during: [ traversalContext withRecursionDetectionFor: objectTwo during: [  ] ].
	self assert: traversalContext repositoriesChain isEmpty.

	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> recursionErrorIsTriggerInSecondStep [
	<gtExample>
	<return: #GtRlReleaseTraversalContext>
	| traversalContext objectOne objectTwo |
	traversalContext := self emptyTraversalContext.
	objectOne := Object new.
	objectTwo := objectOne.

	self
		should: [ traversalContext
				withRecursionDetectionFor: objectOne
				during: [ traversalContext withRecursionDetectionFor: objectTwo during: [  ] ] ]
		raise: Error.
	self assert: traversalContext repositoriesChain size equals: 1.

	^ traversalContext
]

{ #category : #examples }
GtRlReleaseTraversalContextExamples >> recursionErrorIsTriggerInThirdStep [
	<gtExample>
	<return: #GtRlReleaseTraversalContext>
	| traversalContext objectOne objectTwo objectThree |
	traversalContext := self emptyTraversalContext.
	objectOne := GtRlRepositoryRelease new.
	objectOne
		repository: (GtRlRepository new
				loadSpecification: (GtRlRepositoryLoadSpecification fromUrlString: 'some://nice/url1/src')).
	objectTwo := GtRlRepositoryRelease new.
	objectTwo
		repository: (GtRlRepository new
				loadSpecification: (GtRlRepositoryLoadSpecification fromUrlString: 'some://nice/url2/src')).
	objectThree := objectOne.

	self
		should: [ traversalContext
				withRecursionDetectionFor: objectOne
				during: [ traversalContext
						withRecursionDetectionFor: objectTwo
						during: [ traversalContext withRecursionDetectionFor: objectThree during: [  ] ] ] ]
		raise: Error.
	self assert: traversalContext repositoriesChain size equals: 2.

	^ traversalContext
]
