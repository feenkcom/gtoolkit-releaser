Class {
	#name : #GtRlPackagesLoadOrderTraversal,
	#superclass : #Object,
	#category : #'GToolkit-Releaser-Loader'
}

{ #category : #private }
GtRlPackagesLoadOrderTraversal >> loadOrderFor: aPackage in: currentPackages [
	"I traverse first the children recursively, and only after all the children are traversed, 
	I add the current project to the list if needed. The project is added to the list only if 
	it is not already present. If its present it means it was already traversed as it was also
	a child of another release."
	aPackage requiredPackages do: [ :aChildPackage | 
		self loadOrderFor: aChildPackage in: currentPackages ].
	(currentPackages includes: aPackage) ifFalse: [
		currentPackages add: aPackage ].
]

{ #category : #actions }
GtRlPackagesLoadOrderTraversal >> packagesLoadOrderFor: aProject [
	| packagesInLoadOrder |
	packagesInLoadOrder := OrderedCollection new.
	aProject rootPackages do: [ :aPackage | 
		"self loadOrderFor: aPackage in: packagesInLoadOrder" ].
	^ packagesInLoadOrder
]
