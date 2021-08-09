Class {
	#name : 'GtRlCommitIdVersionNumberExamples',
	#superclass : 'GtRlVersionNumberExamples',
	#category : 'GToolkit-Releaser-Examples'
}

{ #category : 'examples' }
GtRlCommitIdVersionNumberExamples >> commitIdVersionNumber [
	<gtExample>
	| commitId versionNumber |
	commitId := '93e56688d40092538efaf24356db9fb2e46521db'.
	versionNumber := GtRlCommitIdVersionNumber new
		commitId: commitId.
	
	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: '93e5668'.
	self assert: versionNumber commitId equals: commitId.
	self assert: versionNumber versionString equals: commitId.
	
	^ versionNumber
	
]

{ #category : 'examples' }
GtRlCommitIdVersionNumberExamples >> commitIdVersionNumberEqualityExample [
	<gtExample>
	| versionNumber anotherEqualVersion anotherNotEqualVersion |
	versionNumber := GtRlCommitIdVersionNumber new
		commitId: '93e56688d40092538efaf24356db9fb2e46521db'.
	anotherEqualVersion := GtRlCommitIdVersionNumber new
		commitId: '93e56688d40092538efaf24356db9fb2e46521db'.
	anotherNotEqualVersion := GtRlCommitIdVersionNumber new
		commitId: '93e56688d40092538efaf24356db9fb2e46521dd'. "One letter difference at the end"
		
	self assert: versionNumber = versionNumber.
	self assert: versionNumber = anotherEqualVersion.
	self assert: (versionNumber = anotherNotEqualVersion) not.
	
	^ versionNumber
	
]

{ #category : 'examples' }
GtRlCommitIdVersionNumberExamples >> uninitializedCommitIdVersionNumber [
	<gtExample>
	| versionNumber |
	versionNumber := GtRlCommitIdVersionNumber new.
	
	self assert: versionNumber isNullVersion not.
	self assert: versionNumber description equals: nil.
	self assert: versionNumber commitId equals: nil.
	self assert: versionNumber versionString equals: nil.
	
	^ versionNumber
	
]
