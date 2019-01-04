Class {
	#name : #GtRlPackageExamples,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-BaselineModel-Examples'
}

{ #category : #examples }
GtRlPackageExamples >> packageWithDependencies [
	<gtExample>
	| package |
	package := self packageWithName.
	package dependencies: #('PackageA' 'PackageB').
	
	self assert: package dependencies equals: #('PackageA' 'PackageB').
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithName [
	<gtExample>
	| package |
	package := GtRlPackage new
		name: 'Package-Main'.
	
	self assert: package name equals: 'Package-Main'.
	self assert: package dependencies isEmpty.
	self assert: package parentProject isNil.
	
	^ package
]

{ #category : #examples }
GtRlPackageExamples >> packageWithinProject [
	<gtExample>
	| package project |
	package := self packageWithName.
	project := GtRlProject withName: 'Container'.
	package parentProject: project.
	
	self assert: package parentProject equals: project.
	self assert: project packages isEmpty.
	
	^ package
]
